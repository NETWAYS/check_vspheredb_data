package cmd

import (
	"fmt"

	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/NETWAYS/go-check/result"
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
	PreRun: func(_ *cobra.Command, _ []string) {
		if datastore == "" {
			queryDatastores()
		} else {
			queryDatastore()
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

	perfData, statusCode := processQueryResults(datastore, capacity, freeSpace)
	pl.Add(&perfData)

	dbConnection.Close()
	check.Exitf(statusCode,
		"Used storage space for datastore %s: %d%% | %s",
		datastore,
		perfData.Value, // this is the used capacity in %
		pl.String())
}

func queryDatastores() {
	var (
		err           error
		datastoreName string
		capacity      int64
		freeSpace     int64
	)

	aggregatedResult := result.Overall{}

	// Parse thresholds from given flags.
	datastoreWarnThreshold, err = check.ParseThreshold(datastoreWarning)
	if err != nil {
		check.ExitError(err)
	}

	datastoreCritThreshold, err = check.ParseThreshold(datastoreCritical)
	if err != nil {
		check.ExitError(err)
	}

	// Collect query results.
	dbConnection := internal.DBConnection(host, port, username, password, database)

	rows, err := dbConnection.Query(`SELECT o.object_name, ds.capacity, ds.free_space 
    	FROM datastore ds 
    	INNER JOIN vcenter vc 
    	ON ds.vcenter_uuid = vc.instance_uuid 
    	INNER JOIN object o 
    	ON ds.uuid = o.uuid
		WHERE vc.name LIKE ?`,
		machine)
	if err != nil {
		check.ExitError(err)
	}

	defer rows.Close()

	// Process query results.
	for rows.Next() {
		// Read row into variables.
		if err = rows.Scan(&datastoreName, &capacity, &freeSpace); err != nil {
			check.ExitError(err)
		}

		// Calculate results and add perf data to list.
		perfData, state := processQueryResults(datastoreName, capacity, freeSpace)
		pl.Add(&perfData)

		// Create PartialResult and add to Overall result.
		pr := result.PartialResult{
			Output: fmt.Sprintf("Used storage for datastore %s: %d%%", datastoreName, perfData.Value),
		}
		if err = pr.SetState(state); err != nil {
			check.ExitError(err)
		}

		aggregatedResult.AddSubcheck(pr)
	}

	dbConnection.Close()

	fmt.Printf("%s | %s\n\n", aggregatedResult.GetOutput(), pl.String())

	check.ExitRaw(aggregatedResult.GetStatus(), aggregatedResult.GetOutput()+" | "+pl.String()) // ExitRaw because of 'nested formatting issues' otherwise.
}

// Computes Perfdata, check result based on the queried data.
func processQueryResults(datastore string, capacity, freeSpace int64) (perfdata.Perfdata, int) {
	// calculate percentage usage for check result decision.
	datastoreUsagePercent := int64(0)
	if capacity != 0 {
		datastoreUsagePercent = (capacity - freeSpace) * 100 / capacity
	}

	// Add Perfdata.
	// percentage usage.
	perfData := perfdata.Perfdata{
		Label: datastore + "_used",
		Value: datastoreUsagePercent,
		Uom:   "%",
		Warn:  datastoreWarnThreshold,
		Crit:  datastoreCritThreshold,
	}

	// Decide on check result state.
	statusCode := check.OK

	if datastoreWarnThreshold.DoesViolate(float64(datastoreUsagePercent)) {
		statusCode = check.Warning
	}

	if datastoreCritThreshold.DoesViolate(float64(datastoreUsagePercent)) {
		statusCode = check.Critical
	}

	return perfData, statusCode
}
