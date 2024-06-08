# Create and configure a Python virtual environment with the required dependencies
.PHONY: install
install:
	rm -rf venv
	virtualenv venv --python=python3.11
	venv/bin/pip install --upgrade pip
	venv/bin/pip install --timeout=60 -r requirements.txt
	venv/bin/pip list

.PHONY: stream-data-to-cassandra
stream-data-to-cassandra:
	rm -rf /tmp/spark-checkpoint-from-kafka-to-cassandra
	venv/bin/python spark_streaming.py

.PHONY: submit-application
submit-application:
	./submit-application.sh
