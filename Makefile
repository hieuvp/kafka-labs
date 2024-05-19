.PHONY: fmt
fmt:
	scripts/update-kafka-connection.sh
	scripts/fmt.sh
