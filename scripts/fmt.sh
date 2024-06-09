#!/usr/bin/env bash

set -eoux pipefail

prettier --write ./*.md
prettier --write ./*.yml
prettier --write ./.*.json
shfmt -i 2 -ci -sr -bn -s -w .envrc

(
  cd scripts
  chmod +x ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w ./*.sh
)

(
  cd infrastructure
  make fmt
)

(
  cd kafka
  make fmt
)

(
  cd spark
  make fmt
)

(
  cd flink
  make fmt
)

(
  cd kstreams
  make fmt
)
