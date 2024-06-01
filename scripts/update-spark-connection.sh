#!/usr/bin/env bash

set -eou pipefail

if ! (cd infrastructure && terraform output -json kafka_private_ip) &> /dev/null; then
  echo "Your infrastructure isn't up and running just yet"
  exit 1
fi

set -x
