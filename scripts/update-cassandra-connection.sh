#!/usr/bin/env bash

set -eou pipefail

if ! (cd infrastructure && terraform output -json kafka_private_ip) &> /dev/null; then
  echo "Your infrastructure isn't up and running just yet"
  exit 1
fi

readonly CASSANDRA_HOST=$(cd infrastructure && terraform output -raw kafka_private_ip)
readonly CASSANDRA_PORT="9042"
readonly CASSANDRA_JDBC_URL="jdbc:cassandra://${CASSANDRA_HOST}:${CASSANDRA_PORT}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Configure .env files
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if ! grep -q "CASSANDRA_HOST=" "spark/.env"; then
  echo "Insert into spark/.env file: CASSANDRA_HOST=${CASSANDRA_HOST}"
  echo "CASSANDRA_HOST=${CASSANDRA_HOST}" | tee -a "spark/.env" > /dev/null
else
  echo "Update spark/.env file: CASSANDRA_HOST=${CASSANDRA_HOST}"
  sed -i "/CASSANDRA_HOST=/cCASSANDRA_HOST=${CASSANDRA_HOST}" "spark/.env"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Configure JetBrains IDE settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

readonly DATA_SOURCE_FILE=".idea/dataSources.xml"
readonly DATA_SOURCE_NAME="Kafka Labs > Cassandra"
readonly DATA_SOURCE_JDBC_URL_XPATH="/project/component/data-source[@name='${DATA_SOURCE_NAME}' and jdbc-driver='com.dbschema.CassandraJdbcDriver']/jdbc-url"
readonly DATA_SOURCE_JDBC_URL=$(xmlstarlet select --template --value-of "$DATA_SOURCE_JDBC_URL_XPATH" "$DATA_SOURCE_FILE")

set -x

if [[ $DATA_SOURCE_JDBC_URL != "$CASSANDRA_JDBC_URL" ]]; then
  xmlstarlet select --template --value-of "$DATA_SOURCE_JDBC_URL_XPATH" -nl "$DATA_SOURCE_FILE"
  xmlstarlet edit --inplace --update "$DATA_SOURCE_JDBC_URL_XPATH" --value "$CASSANDRA_JDBC_URL" "$DATA_SOURCE_FILE"
  xmlstarlet select --template --value-of "$DATA_SOURCE_JDBC_URL_XPATH" -nl "$DATA_SOURCE_FILE"
fi
