.PHONY: fmt
fmt: render-docker-compose-template
	./fmt.sh

.PHONY: render-docker-compose-template
render-docker-compose-template:
	-rm docker-compose.yml
	jinja2 docker-compose.j2.yml \
	  -D host=localhost \
	  > docker-compose.yml

# Create and configure a Python virtual environment with the required dependencies
.PHONY: install
install:
	rm -rf venv
	virtualenv venv --python=python3.11
	venv/bin/pip install --upgrade pip
	venv/bin/pip install --timeout=60 -r requirements.txt
	venv/bin/pip list

# Get all required Docker images built and ready
.PHONY: build-images
build-images:
	./build-images.sh

.PHONY: stream-data-to-cassandra
stream-data-to-cassandra:
	rm -rf /tmp/spark-checkpoint-from-kafka-to-cassandra
	venv/bin/python spark_streaming.py

.PHONY: submit-application
submit-application:
	./submit-application.sh
