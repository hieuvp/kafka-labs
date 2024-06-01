#!/usr/bin/env bash

set -eou pipefail

if ! (cd infrastructure && terraform output -json kafka_private_ip) &> /dev/null; then
  echo "Your infrastructure isn't up and running just yet"
  exit 1
fi

readonly INSTANCE_IP_ADDRESS=$(cd infrastructure && terraform output -raw kafka_private_ip)

readonly SSH_CONFIG_FILE="${HOME}/.ssh/config"
readonly SSH_HOST="kafka-labs"
readonly SSH_HOST_NAME=$(grep -A3 "^Host ${SSH_HOST}$" "$SSH_CONFIG_FILE" | grep "HostName" | awk '{print $2}')

set -x

if [[ -n $SSH_HOST_NAME && $SSH_HOST_NAME != "$INSTANCE_IP_ADDRESS" ]]; then
  sed -i "s/${SSH_HOST_NAME}/${INSTANCE_IP_ADDRESS}/g" "$SSH_CONFIG_FILE"
fi
