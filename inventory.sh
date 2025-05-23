json_input="$1"

jenkins_id=$(echo "$json_input" | jq -r '.jenkins_id.value')
jenkins_private_ip=$(echo "$json_input" | jq -r '.jenkins_private_ip.value')

nginx_id=$(echo "$json_input" | jq -r '.nginx_id.value')
nginx_public_ip=$(echo "$json_input" | jq -r '.nginx_public_ip.value')

slave_id=$(echo "$json_input" | jq -r '.slave_id.value')



cat <<EOF > ansible/inventory
[nginx]
$nginx_id jenkins_ip=$jenkins_private_ip nginx_ip=$nginx_public_ip

[jenkins]
$jenkins_id

[slave]
$slave_id

[remote:children]
nginx
jenkins
slave

[remote:vars]
ansible_connection=community.aws.aws_ssm
ansible_aws_ssm_region=us-east-1
ansible_aws_ssm_bucket_name=iti-ssm-bucket
ansible_become=true
ansible_become_method=sudo
remote_user=ssm-user
EOF
