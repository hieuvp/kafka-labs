#!/usr/bin/env bash

set -eoux pipefail

prettier --write ./*.md
prettier --write ./*.yml
prettier --write ./.*.json
shfmt -i 2 -ci -sr -bn -s -w .envrc

rm docker-compose.yml || true
jinja2 docker-compose.j2.yml \
  -D host=localhost \
  > docker-compose.yml

(
  cd scripts
  chmod +x ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w ./*.sh
)

(
  cd infrastructure

  terraform fmt
  prettier --write ./*.yml
  prettier --write ./*.json

  grep "^[A-Za-z]" "secrets.yml" | sed -E "s/([A-Za-z_]+):(\s+)(.+)/\1: \"<YOUR_\U\1>\"/" > "secrets.yml.example"
  grep "^[A-Za-z]" "terraform.tfvars" | sed -E "s/([A-Za-z_]+)(\s+)=(\s+)(.+)/\1 = \"<YOUR_\U\1>\"/" > "terraform.tfvars.example"
)

(
  cd kafka

  black .

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"
)

(
  cd spark

  prettier --write ./*.yml
  black .
  sql-formatter --config ../.sqlformatterrc.json --fix ./*.sql

  chmod +x ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w .envrc

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"

  rm docker-compose.yml || true
  jinja2 docker-compose.j2.yml \
    -D host=localhost \
    > docker-compose.yml
)

(
  cd flink

  prettier --write ./*.yml

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"
)

(
  cd kstreams

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"
)
