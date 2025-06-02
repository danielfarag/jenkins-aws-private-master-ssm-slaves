output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

output "jenkins_ip" {
  value = aws_instance.jenkins.private_ip
}

output "nginx_id" {
  value = aws_instance.nginx.id
}

output "jenkins_id" {
  value = aws_instance.jenkins.id
}

output "slave_sg" {
  value = aws_security_group.slave.id
}

output "iam_profile_name" {
  value = aws_iam_instance_profile.ssm_ec2_profile.name
}