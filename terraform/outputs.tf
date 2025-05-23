output "nginx_public_ip" {
    value = module.compute.nginx_ip
}

output "jenkins_private_ip" {
    value = module.compute.jenkins_ip
}

output "nginx_id" {
    value = module.compute.nginx_id
}

output "jenkins_id" {
    value = module.compute.jenkins_id
}

output "slave_id" {
    value = module.compute.slave_id
}