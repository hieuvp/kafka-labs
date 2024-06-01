.PHONY: fmt
fmt: update-connection
	scripts/fmt.sh

.PHONY: update-connection
update-connection:
	-scripts/update-ssh-connection.sh
	-scripts/update-kafka-connection.sh
	-scripts/update-spark-connection.sh
	-scripts/update-cassandra-connection.sh
