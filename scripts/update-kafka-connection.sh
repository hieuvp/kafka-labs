#!/usr/bin/env bash

set -eou pipefail

readonly KAFKA_PUBLIC_URL=$(
  jq -r '.tunnels[] | select(.name == "kafka") | .public_url' \
    "infrastructure/ngrok_tunnels.json"
)

readonly KAFKA_BOOTSTRAP_SERVERS=${KAFKA_PUBLIC_URL#tcp://}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Configure .env files
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if ! grep -q "KAFKA_BOOTSTRAP_SERVERS=" "kafka/.env"; then
  echo "Insert into kafka/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  echo "KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" | tee -a "kafka/.env" > /dev/null
else
  echo "Update kafka/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  sed -i "/KAFKA_BOOTSTRAP_SERVERS=/cKAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" "kafka/.env"
fi

if ! grep -q "KAFKA_BOOTSTRAP_SERVERS=" "spark/.env"; then
  echo "Insert into spark/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  echo "KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" | tee -a "spark/.env" > /dev/null
else
  echo "Update spark/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  sed -i "/KAFKA_BOOTSTRAP_SERVERS=/cKAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" "spark/.env"
fi

if ! grep -q "KAFKA_BOOTSTRAP_SERVERS=" "flink/.env"; then
  echo "Insert into flink/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  echo "KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" | tee -a "flink/.env" > /dev/null
else
  echo "Update flink/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  sed -i "/KAFKA_BOOTSTRAP_SERVERS=/cKAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" "flink/.env"
fi

if ! grep -q "KAFKA_BOOTSTRAP_SERVERS=" "kstreams/.env"; then
  echo "Insert into kstreams/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  echo "KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" | tee -a "kstreams/.env" > /dev/null
else
  echo "Update kstreams/.env file: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  sed -i "/KAFKA_BOOTSTRAP_SERVERS=/cKAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" "kstreams/.env"
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Configure JetBrains IDE settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

readonly JETBRAINS_IDE_APPLICATION_PATH="${HOME}/Applications/IntelliJ IDEA Ultimate.app"
readonly JETBRAINS_IDE_SETTINGS_PATH=$(ls -t -Ad "${HOME}/Library/Application Support/JetBrains/"* | grep "IntelliJIdea20" | head -n 1)

readonly KAFKA_SETTINGS_FILE_PATH="${JETBRAINS_IDE_SETTINGS_PATH}/options/bigdataide_settings.xml"
readonly KAFKA_CONNECTION_NAME="Kafka Labs"
readonly KAFKA_CONNECTION_URI_XPATH="/application/component/option/list/ExtendedConnectionData[option[@name=\"groupId\" and @value=\"KafkaConnections\"] and option[@name=\"name\" and @value=\"${KAFKA_CONNECTION_NAME}\"]]/option[@name=\"uri\"]/@value"
readonly KAFKA_CONNECTION_URI=$(xmlstarlet select --template --value-of "$KAFKA_CONNECTION_URI_XPATH" "$KAFKA_SETTINGS_FILE_PATH")
readonly KAFKA_CONNECTION_ID_XPATH="/application/component/option/list/ExtendedConnectionData[option[@name=\"groupId\" and @value=\"KafkaConnections\"] and option[@name=\"name\" and @value=\"${KAFKA_CONNECTION_NAME}\"]]/option[@name=\"innerId\"]/@value"
readonly KAFKA_CONNECTION_ID=$(xmlstarlet select --template --value-of "$KAFKA_CONNECTION_ID_XPATH" "$KAFKA_SETTINGS_FILE_PATH")
readonly KAFKA_KEYCHAIN_SERVICE_NAME="BigDataIDEConnectionSettings@(${KAFKA_CONNECTION_ID}, broker.secret.properties)"

set -x

if [[ $KAFKA_CONNECTION_URI != "$KAFKA_BOOTSTRAP_SERVERS" ]]; then
  xmlstarlet select --template --value-of "$KAFKA_CONNECTION_URI_XPATH" -nl "$KAFKA_SETTINGS_FILE_PATH"
  xmlstarlet edit --inplace --omit-decl --update "$KAFKA_CONNECTION_URI_XPATH" --value "$KAFKA_BOOTSTRAP_SERVERS" "$KAFKA_SETTINGS_FILE_PATH"
  xmlstarlet select --template --value-of "$KAFKA_CONNECTION_URI_XPATH" -nl "$KAFKA_SETTINGS_FILE_PATH"

  security find-generic-password -s "$KAFKA_KEYCHAIN_SERVICE_NAME" | grep "bootstrap.servers="
  security delete-generic-password -s "$KAFKA_KEYCHAIN_SERVICE_NAME"
  security add-generic-password -U -s "$KAFKA_KEYCHAIN_SERVICE_NAME" -a "bootstrap.servers=${KAFKA_BOOTSTRAP_SERVERS}" -T "$JETBRAINS_IDE_APPLICATION_PATH"
  security find-generic-password -s "$KAFKA_KEYCHAIN_SERVICE_NAME" | grep "bootstrap.servers="
fi
