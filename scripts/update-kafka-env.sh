#!/usr/bin/env bash

set -eou pipefail

readonly KAFKA_PUBLIC_URL=$(
  jq -r '.tunnels[] | select(.name == "kafka") | .public_url' \
    "infrastructure/ngrok_tunnels.json"
)

readonly KAFKA_BOOTSTRAP_SERVERS=${KAFKA_PUBLIC_URL#tcp://}

if ! grep -q "KAFKA_BOOTSTRAP_SERVERS=" "kafka/.env"; then
  echo "Adding: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  echo "KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" | tee -a "kafka/.env" > /dev/null
else
  echo "Updating: KAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}"
  sed -i "/KAFKA_BOOTSTRAP_SERVERS=/cKAFKA_BOOTSTRAP_SERVERS=${KAFKA_BOOTSTRAP_SERVERS}" "kafka/.env"
fi
