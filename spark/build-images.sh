#!/usr/bin/env bash

set -eoux pipefail

docker build \
  --file "spark.Dockerfile" \
  --tag "kafka-labs/spark" \
  --build-arg "USERNAME=${SPARK_INSTANCE_USERNAME}" \
  --build-arg "UID=${SPARK_INSTANCE_UID}" \
  --build-arg "GID=${SPARK_INSTANCE_GID}" \
  .
