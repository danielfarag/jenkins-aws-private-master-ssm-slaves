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

output "slave_id" {
  value = aws_instance.slave.id
}