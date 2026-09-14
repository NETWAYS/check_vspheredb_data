package internal

import (
	"context"
	"crypto/tls"
	"crypto/x509"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"time"

	"github.com/NETWAYS/go-check"

	"github.com/go-sql-driver/mysql"
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
func DBConnection(host string, port int16, username string, password string, database string, usetls bool, cacertPath string, clientCertPath string, clientKeyPath string) *sql.DB {
	var connStr string

	if usetls { //nolint:nestif
		TLSConfig := tls.Config{}
		complexConfig := false

		if cacertPath != "" {
			rootCertPool := x509.NewCertPool()

			pem, err := os.ReadFile(cacertPath)
			if err != nil {
				check.ExitError(err)
			}

			if ok := rootCertPool.AppendCertsFromPEM(pem); !ok {
				check.ExitError(errors.New("failed to append PEM"))
			}

			TLSConfig.RootCAs = rootCertPool
			complexConfig = true
		}

		if clientCertPath != "" && clientKeyPath != "" {
			clientCert := make([]tls.Certificate, 0, 1)

			certs, err := tls.LoadX509KeyPair(clientCertPath, clientKeyPath)
			if err != nil {
				check.ExitError(err)
			}

			clientCert = append(clientCert, certs)

			TLSConfig.Certificates = clientCert
			complexConfig = true
		}

		err := mysql.RegisterTLSConfig("custom", &TLSConfig)
		if err != nil {
			check.ExitError(err)
		}

		if complexConfig {
			connStr = fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?tls=custom", username, password, host, port, database)
		} else {
			connStr = fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?tls=true", username, password, host, port, database)
		}
	} else {
		connStr = fmt.Sprintf("%s:%s@tcp(%s:%d)/%s", username, password, host, port, database)
	}

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
