package cmd

import (
	"fmt"

	"github.com/NETWAYS/check_vspheredb_data/internal"

	"github.com/NETWAYS/go-check"
	"github.com/spf13/cobra"
)

var cpuWarning string
var cpuCritical string
var cpuWarnThreshold *check.Threshold
var cpuCritThreshold *check.Threshold

var cpuCmd = &cobra.Command{
	Use:   "cpu",
	Short: "Checks the current CPU usage",
	Run: func(_ *cobra.Command, _ []string) {
		queryCPU()
	},
}

func init() {
	rootCmd.AddCommand(cpuCmd)
	cpuCmd.Flags().StringVarP(&cpuWarning, "warning", "w", "80", "Warning threshold in percent")
	cpuCmd.Flags().StringVarP(&cpuCritical, "critical", "c", "90", "Critical threshold in percent")
}

// Query for CPU usage of the given machine, exit with UNKNOWN on query errors.
func queryCPU() {
	var (
		err              error
		overallCPUUsage  int64
		hardwareCPUMHz   int64
		hardwareCPUCores int64
	)

	// Parse thresholds from given flags.
	cpuWarnThreshold, err = check.ParseThreshold(cpuWarning)
	if err != nil {
		check.ExitError(err)
	}

	cpuCritThreshold, err = check.ParseThreshold(cpuCritical)
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(
		`SELECT hqs.overall_cpu_usage,
 		hs.hardware_cpu_mhz,
		hs.hardware_cpu_cores
		FROM host_quick_stats hqs
		INNER JOIN host_system hs
		ON hqs.uuid = hs.uuid
		WHERE hs.host_name LIKE ?`, machine).Scan(&overallCPUUsage, &hardwareCPUMHz, &hardwareCPUCores)
	if err != nil {
		check.ExitError(err)
	}

	// Calculate percentage usage for check result decision.
	cpuUsagePercent := overallCPUUsage * 100 / (hardwareCPUCores * hardwareCPUMHz)

	// Add performance data
	pl.Add(&check.Perfdata{
		Label: "usage",
		Value: overallCPUUsage,
	})
	pl.Add(&check.Perfdata{
		Label: "usage_percent",
		Value: cpuUsagePercent,
		Uom:   "%",
		Warn:  cpuWarnThreshold,
		Crit:  cpuCritThreshold,
	})
	pl.Add(&check.Perfdata{
		Label: "mhz",
		Value: hardwareCPUMHz,
	})
	pl.Add(&check.Perfdata{
		Label: "cores",
		Value: hardwareCPUCores,
	})

	// Decide on check result state.
	statusCode := check.OK

	if cpuWarnThreshold.DoesViolate(float64(cpuUsagePercent)) {
		statusCode = check.Warning
	}

	if cpuCritThreshold.DoesViolate(float64(cpuUsagePercent)) {
		statusCode = check.Critical
	}

	dbConnection.Close()

	check.ExitWithPerfdata(statusCode, pl, fmt.Sprintf("Total CPU usage is %dGHz (%d%%)", overallCPUUsage/1024, cpuUsagePercent))
}
