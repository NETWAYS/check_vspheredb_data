package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var hbaWarning string
var hbaCritical string
var hbaWarnThreshold *check.Threshold
var hbaCritThreshold *check.Threshold

// hbaCmd represents the hba command.
var hbaCmd = &cobra.Command{
	Use:   "hba",
	Short: "Checks attached HBAs",
	Run: func(_ *cobra.Command, _ []string) {
		queryHba()
	},
}

func init() {
	rootCmd.AddCommand(hbaCmd)

	hbaCmd.Flags().StringVarP(&hbaWarning, "warning", "w", "2", "Warning threshold as Integer (\"less than X available\")")
	hbaCmd.Flags().StringVarP(&hbaCritical, "critical", "c", "1", "Critical threshold as Integer (\"less than X available\")")
}

func queryHba() {
	var (
		hardwareNumHBAs int16
		err             error
	)

	// Parse thresholds from given flags.
	hbaWarnThreshold, err = check.ParseThreshold(hbaWarning + ":") // `:` is needed because warning/critical are reversed.
	if err != nil {
		check.ExitError(err)
	}

	hbaCritThreshold, err = check.ParseThreshold(hbaCritical + ":") // `:` is needed because warning/critical are reversed.
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(`SELECT hardware_num_hba 
        FROM host_system 
        WHERE host_system.host_name LIKE ?`,
		machine).Scan(&hardwareNumHBAs)
	if err != nil {
		check.ExitError(err)
	}

	pl.Add(&perfdata.Perfdata{
		Label: "hbas",
		Value: hardwareNumHBAs,
		Warn:  hbaWarnThreshold,
		Crit:  hbaCritThreshold,
	})

	// Decide on check result state.
	statusCode := check.OK

	if hbaWarnThreshold.DoesViolate(float64(hardwareNumHBAs)) {
		statusCode = check.Warning
	}

	if hbaCritThreshold.DoesViolate(float64(hardwareNumHBAs)) {
		statusCode = check.Critical
	}

	dbConnection.Close()
	check.Exitf(statusCode,
		"Number of HBAs: %d | %s",
		hardwareNumHBAs,
		pl.String())
}
