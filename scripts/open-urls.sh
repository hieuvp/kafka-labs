#!/usr/bin/env bash

set -eou pipefail

readonly PRIVATE_IP_ADDRESS=$(cd infrastructure && terraform output -raw kafka_private_ip)

mapfile -t NGROK_PUBLIC_URLS < <(
  jq -r ".tunnels[].public_url" "infrastructure/ngrok_tunnels.json"
)

# https://dashboard.ngrok.com/cloud-edge/endpoints
echo "ngrok Endpoints:"
for public_url in "${NGROK_PUBLIC_URLS[@]}"; do
  if [[ $public_url == https://* ]]; then
    echo "$public_url"
    open "$public_url"
  else
    echo "$public_url"
  fi
done

printf "\nPrivate IP Address:\n"
echo "tcp://${PRIVATE_IP_ADDRESS}:9092"
echo "http://${PRIVATE_IP_ADDRESS}:8080"
echo "http://${PRIVATE_IP_ADDRESS}:9021"
