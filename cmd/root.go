package cmd

import (
	"github.com/NETWAYS/check_vspheredb_data/internal"

	"github.com/NETWAYS/go-check"
	"github.com/spf13/cobra"
)

// Flag var definitions.
var machine string
var host string
var port int16
var database string
var username string
var password string
var credentialsFile string

var pl check.PerfdataList

var rootCmd = &cobra.Command{
	Use:   "check_vspheredb_data",
	Short: "A check plugin for retrieving performance data of vSphere hosts collected by Icingaweb2's vSphereDB module.",
	Long: `The vSphereDB module collects performance data from the vCenters it queries, but without proper alert management.
This plugin allows to query the collected data via vSphereDB's database tables and enables.`,

	// Check global flags - `machine` and `host` need to be set,
	// and `credentialsFile` needs to be valid if present.
	PersistentPreRun: func(cmd *cobra.Command, _ []string) {
		if machine == "" {
			cmd.DisableAutoGenTag = true

			check.Exit(check.Unknown, "Error: --machine flag is required")
		}

		if host == "" {
			cmd.DisableAutoGenTag = true

			check.Exit(check.Unknown, "Error: --host flag is required")
		}
		// Parse credentials file.
		if credentialsFile != "" {
			internal.ParseCredentialsFile(credentialsFile, &username, &password)
		}
	},
}

func Execute() {
	cobra.CheckErr(rootCmd.Execute())
}

func init() {
	rootCmd.PersistentFlags().StringVarP(&machine, "machine", "m", "", "Machine to be queried for")
	rootCmd.PersistentFlags().StringVarP(&host, "host", "H", "", "Database host to connect to")
	rootCmd.PersistentFlags().Int16VarP(&port, "port", "p", 3306, "Database port to connect to")
	rootCmd.PersistentFlags().StringVarP(&database, "database", "d", "vspheredb", "Database name")
	rootCmd.PersistentFlags().StringVarP(&username, "username", "u", "vspheredb", "Database username")
	rootCmd.PersistentFlags().StringVarP(&password, "password", "P", "vspheredb", "Database password")
	rootCmd.PersistentFlags().StringVarP(&credentialsFile, "credentials-file", "f", "", "Path to the credentials file")
}
