#!/usr/bin/env bash

set -eoux pipefail

prettier --write ./*.md
prettier --write ./*.yml

rm docker-compose.yml
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

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"
)

(
  cd flink

  prettier --write ./*.yml

  grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"
)
