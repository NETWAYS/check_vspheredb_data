package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var nicWarning string
var nicCritical string
var nicWarnThreshold *check.Threshold
var nicCritThreshold *check.Threshold

// nicCmd represents the nic command.
var nicCmd = &cobra.Command{
	Use:   "nic",
	Short: "Checks attached NICs",
	Run: func(_ *cobra.Command, _ []string) {
		queryNic()
	},
}

func init() {
	rootCmd.AddCommand(nicCmd)

	nicCmd.Flags().StringVarP(&nicWarning, "warning", "w", "2", "Warning threshold as Integer (\"less than X available\")")
	nicCmd.Flags().StringVarP(&nicCritical, "critical", "c", "1", "Critical threshold as Integer (\"less than X available\")")
}

func queryNic() {
	var (
		err             error
		hardwareNumNICs int16
	)

	// Parse thresholds from given flags.
	nicWarnThreshold, err = check.ParseThreshold(nicWarning + ":") // `:` is needed because warning/critical are reversed.
	if err != nil {
		check.ExitError(err)
	}

	nicCritThreshold, err = check.ParseThreshold(nicCritical + ":") // `:` is needed because warning/critical are reversed.
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(`SELECT hardware_num_nic 
            FROM host_system 
            WHERE host_system.host_name LIKE ?`,
		machine).Scan(&hardwareNumNICs)
	if err != nil {
		check.ExitError(err)
	}

	pl.Add(&perfdata.Perfdata{
		Label: "nics",
		Value: hardwareNumNICs,
		Warn:  nicWarnThreshold,
		Crit:  nicCritThreshold,
	})

	// Decide on check result state.
	statusCode := check.OK

	if nicWarnThreshold.DoesViolate(float64(hardwareNumNICs)) {
		statusCode = check.Warning
	}

	if nicCritThreshold.DoesViolate(float64(hardwareNumNICs)) {
		statusCode = check.Critical
	}

	dbConnection.Close()
	check.Exitf(statusCode,
		"Number of NICs: %d | %s",
		hardwareNumNICs,
		pl.String())
}
