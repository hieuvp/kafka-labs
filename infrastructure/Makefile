.PHONY: install
install:
	rm -rf .terraform .terraform.lock.hcl
	terraform init
	terraform destroy -auto-approve
	terraform apply -auto-approve
	ansible-playbook playbook.yml --tags configure
