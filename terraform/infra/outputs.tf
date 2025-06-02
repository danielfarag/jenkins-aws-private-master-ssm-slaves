output "nginx_public_ip" {
    value = module.compute.nginx_ip
}

output "jenkins_id" {
    value = module.compute.jenkins_id
}

output "nginx_id" {
    value = module.compute.nginx_id
}



output "jenkins_connection" {
    value = "aws ssm start-session --target ${module.compute.jenkins_id} --region ${var.region}"
}

output "nginx_connection" {
    value = "aws ssm start-session --target ${module.compute.nginx_id} --region ${var.region}"
}

output "jenkins_password" {
  value = "aws ssm start-session --target ${module.compute.jenkins_id} --region ${var.region} --document-name 'AWS-StartInteractiveCommand' --parameters 'command=\"sudo cat /var/lib/jenkins/secrets/initialAdminPassword\"'"
}



output "region" {
  value=var.region
}
output "availability_zone" {
  value=var.availability_zone
}


output "private_subnet" {
  value = module.network.private_subnet.id
}

output "slave_sg" {
  value=module.compute.slave_sg
}
output "iam_profile_name" {
  value=module.compute.iam_profile_name
}
