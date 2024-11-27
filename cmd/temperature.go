package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"
	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/perfdata"
	"github.com/spf13/cobra"
)

var temperatureWarning string
var temperatureCritical string
var temperatureWarnThreshold *check.Threshold
var temperatureCritThreshold *check.Threshold

// temperatureCmd represents the temperature command.
var temperatureCmd = &cobra.Command{
	Use:   "temperature",
	Short: "Checks temperature",
	Run: func(_ *cobra.Command, _ []string) {
		queryTemperature()
	},
}

func init() {
	rootCmd.AddCommand(temperatureCmd)

	temperatureCmd.Flags().StringVarP(&temperatureWarning, "warning", "w", "50", "Warning threshold as Integer")
	temperatureCmd.Flags().StringVarP(&temperatureCritical, "critical", "c", "60", "Critical threshold as Integer")
}

func queryTemperature() {
	var (
		err            error
		currentReading int64
	)

	// Parse thresholds from given flags.
	temperatureWarnThreshold, err = check.ParseThreshold(temperatureWarning)
	if err != nil {
		check.ExitError(err)
	}

	temperatureCritThreshold, err = check.ParseThreshold(temperatureCritical)
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)

	err = dbConnection.QueryRow(`SELECT se.current_reading 
        FROM host_sensor se 
        INNER JOIN host_system hs 
        ON se.host_uuid = hs.uuid 
        WHERE hs.host_name LIKE ?
		AND se.name LIKE "System Board 1 Inlet Temp"`,
		machine).Scan(&currentReading)
	if err != nil {
		check.ExitError(err)
	}

	pl.Add(&perfdata.Perfdata{
		Label: "temp",
		Value: currentReading,
		Uom:   "C",
		Warn:  temperatureWarnThreshold,
		Crit:  temperatureCritThreshold,
	})

	// Decide on check result state.
	statusCode := check.OK

	if temperatureWarnThreshold.DoesViolate(float64(currentReading)) {
		statusCode = check.Warning
	}

	if temperatureCritThreshold.DoesViolate(float64(currentReading)) {
		statusCode = check.Critical
	}

	dbConnection.Close()
	check.Exitf(statusCode,
		"Temperature is %d°C | %s",
		currentReading,
		pl.String())
}
