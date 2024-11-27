package internal

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"os"

	"github.com/NETWAYS/go-check"

	// needed to use the MySQL driver for the sql module.
	_ "github.com/go-sql-driver/mysql"
)

// Credentials file JSON spec

type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// Try to parse a given credentialsFile and write the parsed credentials to
// `user` and `password` variables
// Credential files are required to be JSON object of the following spec:
// `{"username": "vspheredb", "password": "vspheredb"}`
//
// If parsing fails, check exits with UNKNOWN state.
func ParseCredentialsFile(credentialsFile string, username *string, password *string) {
	// Check if file exists, exit with UNKNOWN otherwise.
	if _, err := os.Stat(credentialsFile); os.IsNotExist(err) {
		check.ExitError(err)
	}

	// Read the file, exit with UNKNOWN otherwise.
	content, err := os.ReadFile(credentialsFile)
	if err != nil {
		check.ExitError(err)
	}

	// Parse file contents into known JSON struct.
	var data Credentials
	if err := json.Unmarshal(content, &data); err != nil {
		check.ExitError(err)
	}

	*username = data.Username
	*password = data.Password
}

// Establishes and checks DB connection and returns the connection.
func DBConnection(host string, port int16, username string, password string, database string) *sql.DB {
	connStr := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", username, password, host, port, database)

	// Open connection.
	db, err := sql.Open("mysql", connStr)
	if err != nil {
		check.ExitError(err)
	}
	// Test connection.
	if err := db.Ping(); err != nil {
		check.ExitError(err)
	}

	return db
}
