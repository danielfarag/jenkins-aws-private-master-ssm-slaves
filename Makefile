.PHONY: terraform inventory ansible auth clean

terraform:
	@terraform -chdir=terraform init
	@terraform -chdir=terraform apply -auto-approve

inventory:
	@./inventory.sh "$$(terraform -chdir=terraform output -json)"

ansible:
	@cd ./ansible && ansible-playbook jenkins.yaml
	@cd ./ansible && ansible-playbook nginx.yaml
	@cd ./ansible && ansible-playbook slave.yaml

auth:
	@echo jenkins_server   	= $$(terraform -chdir=terraform output -raw nginx_public_ip)
	@echo jenkins_password 	= $$(cat ansible/password)
	@echo slave_id  		= $$(terraform -chdir=terraform output -raw slave_id); 
	@echo "connect to slave using = aws ssm start-session --target <slave-id> --region <region>"

clean:
	@terraform -chdir=terraform destroy -auto-approve