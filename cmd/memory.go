package cmd

import (
	"fmt"

	"github.com/NETWAYS/check_vspheredb_data/internal"

	"github.com/NETWAYS/go-check"
	"github.com/spf13/cobra"
)

var memoryWarning string
var memoryCritical string
var memoryWarnThreshold *check.Threshold
var memoryCritThreshold *check.Threshold

var memoryCmd = &cobra.Command{
	Use:   "memory",
	Short: "Checks the current memory usage",
	Run: func(_ *cobra.Command, _ []string) {
		queryMemory()
	},
}

func init() {
	rootCmd.AddCommand(memoryCmd)

	memoryCmd.Flags().StringVarP(&memoryWarning, "warning", "w", "80", "Warning threshold in percent")
	memoryCmd.Flags().StringVarP(&memoryCritical, "critical", "c", "90", "Critical threshold in percent")
}

// Query for memory usage of the given machine, exit with UNKNOWN on query errors.
func queryMemory() {
	var (
		overallMemoryUsageMB int64
		hardwareMemorySizeMB int64
		err                  error
	)

	// Parse thresholds from given flags.
	memoryWarnThreshold, err = check.ParseThreshold(memoryWarning)
	if err != nil {
		check.ExitError(err)
	}

	memoryCritThreshold, err = check.ParseThreshold(memoryCritical)
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(
		`SELECT hqs.overall_memory_usage_mb,
        hs.hardware_memory_size_mb
        FROM host_quick_stats hqs
        INNER JOIN host_system hs
        ON hqs.uuid = hs.uuid
        WHERE hs.host_name LIKE ?`, machine).Scan(&overallMemoryUsageMB, &hardwareMemorySizeMB)
	if err != nil {
		check.ExitError(err)
	}

	// calculate percentage usage for check result decision.
	memoryUsagePercent := overallMemoryUsageMB * 100 / hardwareMemorySizeMB

	pl.Add(&check.Perfdata{
		Label: "usage",
		Value: overallMemoryUsageMB * 1024 * 1024, // Report in Bytes.
		Uom:   "B",
	})
	pl.Add(&check.Perfdata{
		Label: "usage_percent",
		Value: memoryUsagePercent,
		Uom:   "%",
		Warn:  memoryWarnThreshold,
		Crit:  memoryCritThreshold,
	})

	// Decide on check result state.
	statusCode := check.OK

	if memoryWarnThreshold.DoesViolate(float64(memoryUsagePercent)) {
		statusCode = check.Warning
	}

	if memoryCritThreshold.DoesViolate(float64(memoryUsagePercent)) {
		statusCode = check.Critical
	}

	dbConnection.Close()
	check.ExitWithPerfdata(statusCode, pl, fmt.Sprintf("Total Memory usage is %dGB (%d%%)", overallMemoryUsageMB/1024, memoryUsagePercent))
}
