package internal

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"os"
	"time"

	"github.com/NETWAYS/go-check"

	// needed to use the MySQL driver for the sql module.
	_ "github.com/go-sql-driver/mysql"
)

// Credentials file JSON spec

type Credentials struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

// ParseCredentialsFile tries to parse a given credentialsFile and write the parsed credentials to
// `user` and `password` variables
// Credential files are required to be JSON object of the following spec:
// `{"username": "vspheredb", "password": "vspheredb"}`
//
// If parsing fails, check exits with UNKNOWN state.
func ParseCredentialsFile(credentialsFile string, username *string, password *string) {
	// Check if file exists, exit with UNKNOWN otherwise.
	_, err := os.Stat(credentialsFile)
	if os.IsNotExist(err) {
		check.ExitError(err)
	}

	// Read the file, exit with UNKNOWN otherwise.
	content, err := os.ReadFile(credentialsFile)
	if err != nil {
		check.ExitError(err)
	}

	// Parse file contents into known JSON struct.
	var data Credentials

	err = json.Unmarshal(content, &data)
	if err != nil {
		check.ExitError(err)
	}

	*username = data.Username
	*password = data.Password
}

// DBConnection establishes and checks DB connection and returns the connection.
func DBConnection(host string, port int16, username string, password string, database string) *sql.DB {
	connStr := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", username, password, host, port, database)

	// Open connection.
	db, err := sql.Open("mysql", connStr)
	if err != nil {
		check.ExitError(err)
	}
	// Test connection.
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	err = db.PingContext(ctx)
	if err != nil {
		check.ExitError(err)
	}

	return db
}
