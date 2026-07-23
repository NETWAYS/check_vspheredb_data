package cmd

import (
	"fmt"

	"github.com/NETWAYS/check_vspheredb_data/internal"

	"github.com/NETWAYS/go-check"
	"github.com/NETWAYS/go-check/result"
	"github.com/spf13/cobra"
)

var temperatureWarning string
var temperatureCritical string
var temperatureSensor string
var temperatureWarnThreshold *check.Threshold
var temperatureCritThreshold *check.Threshold

// temperatureCmd represents the temperature command.
var temperatureCmd = &cobra.Command{
	Use:   "temperature",
	Short: "Checks the temperature of sensors",
	Run: func(_ *cobra.Command, _ []string) {
		queryTemperature()
	},
}

func init() {
	rootCmd.AddCommand(temperatureCmd)

	temperatureCmd.Flags().StringVarP(&temperatureWarning, "warning", "w", "50", "Warning threshold")
	temperatureCmd.Flags().StringVarP(&temperatureCritical, "critical", "c", "60", "Critical threshold")
	temperatureCmd.Flags().StringVarP(&temperatureSensor, "sensor", "", "%", "Sensor name filter (supports SQL LIKE pattern)")
}

func queryTemperature() {
	var (
		err error
	)

	temperatureWarnThreshold, err = check.ParseThreshold(temperatureWarning)
	if err != nil {
		check.ExitError(err)
	}

	temperatureCritThreshold, err = check.ParseThreshold(temperatureCritical)
	if err != nil {
		check.ExitError(err)
	}

	dbConnection := internal.DBConnection(host, port, username, password, database)
	defer dbConnection.Close()

	rows, err := dbConnection.Query(`SELECT se.name, se.current_reading
        FROM host_sensor se
        INNER JOIN host_system hs
        ON se.host_uuid = hs.uuid
        WHERE hs.host_name LIKE ?
		AND se.sensor_type = "temperature"
		AND se.name LIKE ?`,
		machine, temperatureSensor)
	if err != nil {
		check.ExitError(err)
	}
	defer rows.Close()

	o := result.Overall{}

	var sensorCount int

	var maxTemp int64

	for rows.Next() {
		var sensorName string

		var currentReading int64

		err := rows.Scan(&sensorName, &currentReading)
		if err != nil {
			check.ExitError(err)
		}

		// The division by 100 is necessary here, to do the temperature calculation and output correctly - otherwise we would have wrong temperature results, because vsphereDB saves the temperatures to its database without any separators.
		currentReading /= 100
		sensorCount++

		if currentReading > maxTemp {
			maxTemp = currentReading
		}

		pr := result.NewPartialResult()
		pr.SetState(check.OK)

		if temperatureWarnThreshold.DoesViolate(float64(currentReading)) {
			pr.SetState(check.Warning)
		}

		if temperatureCritThreshold.DoesViolate(float64(currentReading)) {
			pr.SetState(check.Critical)
		}

		pr.AddPerfdata(&check.Perfdata{
			Label: "temp",
			Value: currentReading,
			Uom:   "C",
			Warn:  temperatureWarnThreshold,
			Crit:  temperatureCritThreshold,
		})

		pr.SetOutput(fmt.Sprintf("%s is %d Celsius", sensorName, currentReading))

		o.AddSubcheck(pr)
	}

	check.Exit(o.GetStatus(), o.GetOutput())
}
