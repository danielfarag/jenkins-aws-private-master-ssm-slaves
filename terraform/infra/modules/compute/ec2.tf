resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  subnet_id     = var.public_subnet.id 
  associate_public_ip_address = true
  availability_zone = var.availability_zone
  depends_on = [ aws_instance.jenkins ]
  user_data = templatefile("${path.module}/nginx_install.sh", {
    jenkins_ip = aws_instance.jenkins.private_ip 
  })

  vpc_security_group_ids = [ aws_security_group.nginx.id ]
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.id
  tags = {
    Name = "Nginx Server"
    Group = "Group1"
    Target = "Master"
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  subnet_id     = var.private_subnet.id 
  availability_zone = var.availability_zone
  vpc_security_group_ids = [ aws_security_group.jenkins.id ]
  user_data = base64encode(file("${path.module}/jenkins.sh"))
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.id
  tags = {
    Name = "Master server"
    Group = "Group1"
    Jenkins = "Master"
  }
}