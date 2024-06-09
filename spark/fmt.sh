#!/usr/bin/env bash

set -eoux pipefail

chmod +x ./*.sh
shfmt -i 2 -ci -sr -bn -s -w ./*.sh
shfmt -i 2 -ci -sr -bn -s -w .envrc

grep "^[A-Za-z]" ".env" | sed -E "s/(.+)=(.+)/\1=<YOUR_\U\1>/" > ".env.example"

prettier --write ./*.yml
sql-formatter --config ../.sqlformatterrc.json --fix ./*.sql

black .
isort .
