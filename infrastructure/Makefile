.PHONY: install
install:
	rm -rf .terraform .terraform.lock.hcl
	terraform init
	terraform destroy -auto-approve
	terraform apply -auto-approve

	sleep 3s
	# cd .. && scripts/init-ansible.sh
	ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook playbook.yml

	sleep 3s
	cd .. && scripts/open-urls.sh
