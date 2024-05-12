#!/usr/bin/env bash

set -eoux pipefail

prettier --write ./*.md
prettier --write ./*.yml

rm docker-compose.local.yml
jinja2 docker-compose.j2.yml \
  -D host=localhost \
  > docker-compose.local.yml

(
  cd scripts
  chmod +x ./*.sh
  shfmt -i 2 -ci -sr -bn -s -w ./*.sh
)

(
  cd infrastructure

  terraform fmt
  prettier --write ./*.yml

  grep "^[A-Za-z]" "secrets.yml" | sed -E "s/([A-Za-z_]+):(\s+)(.+)/\1: \"<YOUR_\U\1>\"/" > "secrets.yml.example"
  grep "^[A-Za-z]" "terraform.tfvars" | sed -E "s/([A-Za-z_]+)(\s+)=(\s+)(.+)/\1 = \"<YOUR_\U\1>\"/" > "terraform.tfvars.example"
)
