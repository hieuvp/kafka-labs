#!/usr/bin/env bash

set -eoux pipefail

chmod +x ./*.sh
shfmt -i 2 -ci -sr -bn -s -w ./*.sh

terraform fmt
prettier --write ./*.yml
prettier --write ./*.json

grep "^[A-Za-z]" "secrets.yml" | sed -E "s/([A-Za-z_]+):(\s+)(.+)/\1: \"<YOUR_\U\1>\"/" > "secrets.yml.example"
grep "^[A-Za-z]" "terraform.tfvars" | sed -E "s/([A-Za-z_]+)(\s+)=(\s+)(.+)/\1 = \"<YOUR_\U\1>\"/" > "terraform.tfvars.example"
