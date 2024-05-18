.PHONY: fmt
fmt:
	scripts/update-kafka-env.sh
	scripts/fmt.sh
