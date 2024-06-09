.PHONY: fmt
fmt:
	./fmt.sh

# Create and configure a Python virtual environment with the required dependencies
.PHONY: install
install:
	rm -rf venv
	virtualenv venv --python=python3.11
	venv/bin/pip install --upgrade pip
	venv/bin/pip install -r requirements.txt
	venv/bin/pip list

.PHONY: generate-data
generate-data:
	venv/bin/python kafka_producer.py
