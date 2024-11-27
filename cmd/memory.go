package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var memoryWarning string
var memoryCritical string
var memoryWarnThreshold *check.Threshold
var memoryCritThreshold *check.Threshold

// memoryCmd represents the memory command.
var memoryCmd = &cobra.Command{
	Use:   "memory",
	Short: "Checks memory usage",
	Run: func(_ *cobra.Command, _ []string) {
		queryMemory()
	},
}

func init() {
	rootCmd.AddCommand(memoryCmd)

	memoryCmd.Flags().StringVarP(&memoryWarning, "warning", "w", "80", "Warning threshold in percent as Integer")
	memoryCmd.Flags().StringVarP(&memoryCritical, "critical", "c", "90", "Critical threshold in percent as Integer")
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

	// Add Perfdata.
	// total usage.
	pl.Add(&perfdata.Perfdata{
		Label: "usage",
		Value: overallMemoryUsageMB * 1024 * 1024, // Report in Bytes.
		Uom:   "B",
	})
	// percentage usage.
	pl.Add(&perfdata.Perfdata{
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
	check.Exitf(statusCode,
		"Total Memory usage is %dGB (%d%%) | %s",
		overallMemoryUsageMB/1024,
		memoryUsagePercent,
		pl.String())
}
