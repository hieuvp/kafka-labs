#!/usr/bin/env bash

set -eoux pipefail

scp ".env" "kafka-labs:${SPARK_MODULE_PATH}"
scp "spark-packages.conf" "kafka-labs:${SPARK_MODULE_PATH}"
scp "spark_streaming.py" "kafka-labs:${SPARK_MODULE_PATH}"

# Spark Configuration > Spark UI
# https://spark.apache.org/docs/3.5.0/configuration.html#spark-ui

(
  sleep 15s
  open "http://${SPARK_INSTANCE_IP_ADDRESS}:5050"
) &

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

export CASSANDRA_HOST="cassandra-node-1"

readonly SPARK_PACKAGES=$(paste -s -d "," "spark-packages.conf")

set -x

pkill -f "spark_streaming.py" || true

spark-submit \
  --master "spark://spark-master:7077" \
  --properties-file "spark-defaults.conf" \
  --conf "spark.ui.port=5050" \
  --conf "spark.eventLog.dir=file:${SPARK_MODULE_PATH}/events" \
  --packages "$SPARK_PACKAGES" \
  "spark_streaming.py"

ENDSSH
