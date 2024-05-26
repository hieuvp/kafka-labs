.PHONY: fmt
fmt:
	scripts/update-kafka-connection.sh
	scripts/update-cassandra-connection.sh
	scripts/fmt.sh
