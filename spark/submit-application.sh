#!/usr/bin/env bash

set -eoux pipefail

scp ".env" "kafka-labs:${SPARK_MODULE_PATH}"
scp "spark-packages.conf" "kafka-labs:${SPARK_MODULE_PATH}"
scp "spark_streaming.py" "kafka-labs:${SPARK_MODULE_PATH}"

ssh "kafka-labs" \
  SPARK_MODULE_PATH="$SPARK_MODULE_PATH" \
  "bash -s" << "ENDSSH"

cd "$SPARK_MODULE_PATH"

source "${HOME}/.sdkman/bin/sdkman-init.sh"
sdk env
echo

source "venv/bin/activate"
which python pip
python --version && pip --version
echo

set -eou pipefail

readonly SPARK_PACKAGES=$(paste -s -d "," "spark-packages.conf")

set -x

spark-submit \
  --master "spark://localhost:7077" \
  --packages "$SPARK_PACKAGES" \
  "spark_streaming.py"

ENDSSH
