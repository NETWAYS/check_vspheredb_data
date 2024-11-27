package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var datastoreWarning string
var datastoreCritical string
var datastoreWarnThreshold *check.Threshold
var datastoreCritThreshold *check.Threshold
var datastore string

// datastoreCmd represents the datastore command.
var datastoreCmd = &cobra.Command{
	Use:   "datastore",
	Short: "Checks all datastores or a singular, specified datastore",
	Run: func(_ *cobra.Command, _ []string) {
		queryDatastore()
	},
	PreRun: func(cmd *cobra.Command, _ []string) {
		if datastore == "" {
			cmd.DisableAutoGenTag = true
			check.Exitf(check.Unknown, "Error: --datastore flag is required")
		}
	},
}

func init() {
	rootCmd.AddCommand(datastoreCmd)

	datastoreCmd.Flags().StringVarP(&datastoreWarning, "warning", "w", "80", "Warning threshold in percent as Integer")
	datastoreCmd.Flags().StringVarP(&datastoreCritical, "critical", "c", "90", "Critical threshold in percent as Integer")
	datastoreCmd.Flags().StringVarP(&datastore, "datastore", "s", "", "Datastore to check")
}

func queryDatastore() {
	var (
		err       error
		capacity  int64
		freeSpace int64
	)

	// Parse thresholds from given flags.
	datastoreWarnThreshold, err = check.ParseThreshold(datastoreWarning)
	if err != nil {
		check.ExitError(err)
	}

	datastoreCritThreshold, err = check.ParseThreshold(datastoreCritical)
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(`SELECT ds.capacity, ds.free_space 
    	FROM datastore ds 
    	INNER JOIN vcenter vc 
    	ON ds.vcenter_uuid = vc.instance_uuid 
    	INNER JOIN object o 
    	ON ds.uuid = o.uuid
		WHERE o.object_name LIKE ?
		AND vc.name LIKE ?`,
		datastore,
		machine).Scan(&capacity, &freeSpace)
	if err != nil {
		check.ExitError(err)
	}

	// calculate percentage usage for check result decision.
	datastoreUsagePercent := int64(0)
	if capacity != 0 {
		datastoreUsagePercent = (capacity - freeSpace) * 100 / capacity
	}

	// Add Perfdata.
	// percentage usage.
	pl.Add(&perfdata.Perfdata{
		Label: "used",
		Value: datastoreUsagePercent,
		Uom:   "%",
		Warn:  datastoreWarnThreshold,
		Crit:  datastoreCritThreshold,
	})

	// Decide on check result state.
	statusCode := check.OK

	if datastoreWarnThreshold.DoesViolate(float64(datastoreUsagePercent)) {
		statusCode = check.Warning
	}

	if datastoreCritThreshold.DoesViolate(float64(datastoreUsagePercent)) {
		statusCode = check.Critical
	}

	dbConnection.Close()
	check.Exitf(statusCode,
		"Used storage space for datastore %s: %d%% | %s",
		datastore,
		datastoreUsagePercent,
		pl.String())
}
