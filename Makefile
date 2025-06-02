.PHONY: terraform inventory ansible auth clean
nginx_public_ip = $$(terraform -chdir=terraform/infra output -raw nginx_public_ip)
nginx_id = $$(terraform -chdir=terraform/infra output -raw nginx_id)
jenkins_id = $$(terraform -chdir=terraform/infra output -raw jenkins_id)
nginx_connection = $$(terraform -chdir=terraform/infra output -raw nginx_connection)
jenkins_connection = $$(terraform -chdir=terraform/infra output -raw jenkins_connection)
jenkins_password = $$(terraform -chdir=terraform/infra output -raw jenkins_password)

region = $$(terraform -chdir=terraform/infra output -raw region)
private_subnet = $$(terraform -chdir=terraform/infra output -raw private_subnet)
slave_sg = $$(terraform -chdir=terraform/infra output -raw slave_sg)
iam_profile_name = $$(terraform -chdir=terraform/infra output -raw iam_profile_name)

infra:
	@terraform -chdir=terraform/infra init
	@terraform -chdir=terraform/infra apply -auto-approve

slaves:
	@terraform -chdir=terraform/slave init
	@terraform -chdir=terraform/slave apply -var="region=${region}" -var="private_subnet=${private_subnet}" -var="slave_sg=${slave_sg}" -var="iam_profile_name=${iam_profile_name}" -auto-approve

connections:
	@echo jenkins 
	@echo - ${jenkins_id}
	@echo - ${jenkins_connection}
	@echo - ${jenkins_password}


	@echo ""
	@echo nginx
	@echo - ${nginx_public_ip}
	@echo - ${nginx_id}
	@echo - ${nginx_connection}

	
clean:
	@terraform -chdir=terraform/slave destroy -var="region=${region}" -var="private_subnet=${private_subnet}" -var="slave_sg=${slave_sg}" -var="iam_profile_name=${iam_profile_name}" -auto-approve
	@terraform -chdir=terraform/infra destroy -auto-approve