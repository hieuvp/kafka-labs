.PHONY: fmt
fmt: render-docker-compose-template update-connection
	scripts/fmt.sh

.PHONY: render-docker-compose-template
render-docker-compose-template:
	-rm docker-compose.yml
	jinja2 docker-compose.j2.yml \
	  -D host=localhost \
	  > docker-compose.yml

.PHONY: update-connection
update-connection:
	-scripts/update-ssh-connection.sh
	-scripts/update-kafka-connection.sh
	-scripts/update-spark-connection.sh
	-scripts/update-cassandra-connection.sh
