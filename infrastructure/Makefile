.PHONY: install
install:
	rm -rf .terraform .terraform.lock.hcl
	terraform init
	cd .. && scripts/init-ansible.sh

	terraform destroy -auto-approve
	terraform apply -auto-approve

	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml
