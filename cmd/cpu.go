package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var cpuWarning string
var cpuCritical string
var cpuWarnThreshold *check.Threshold
var cpuCritThreshold *check.Threshold

// cpuCmd represents the cpu command.
var cpuCmd = &cobra.Command{
	Use:   "cpu",
	Short: "Checks CPU usage",
	Run: func(_ *cobra.Command, _ []string) {
		queryCPU()
	},
}

func init() {
	rootCmd.AddCommand(cpuCmd)
	cpuCmd.Flags().StringVarP(&cpuWarning, "warning", "w", "80", "Warning threshold in percent as Integer")
	cpuCmd.Flags().StringVarP(&cpuCritical, "critical", "c", "90", "Critical threshold in percent as Integer")
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

	// calculate percentage usage for check result decision.
	cpuUsagePercent := overallCPUUsage * 100 / (hardwareCPUCores * hardwareCPUMHz)

	// Add Perfdata.
	// total usage.
	pl.Add(&perfdata.Perfdata{
		Label: "usage",
		Value: overallCPUUsage,
	})
	// usage in percent, including thresholds.
	pl.Add(&perfdata.Perfdata{
		Label: "usage_percent",
		Value: cpuUsagePercent,
		Uom:   "%",
		Warn:  cpuWarnThreshold,
		Crit:  cpuCritThreshold,
	})
	// mhz.
	pl.Add(&perfdata.Perfdata{
		Label: "mhz",
		Value: hardwareCPUMHz,
	})
	// cores.
	pl.Add(&perfdata.Perfdata{
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
	check.Exitf(statusCode,
		"Total CPU usage is %dGHz (%d%%) | %s",
		overallCPUUsage/1024,
		cpuUsagePercent,
		pl.String())
}
