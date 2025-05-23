resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  subnet_id     = var.public_subnet.id 
  associate_public_ip_address = true
  availability_zone = var.availability_zone
  user_data = base64encode(file("${path.module}/ssm-agent.sh"))
  vpc_security_group_ids = [ aws_security_group.nginx.id ]
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.id
  tags = {
    Name = "Nginx Server"
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  subnet_id     = var.private_subnet.id 
  availability_zone = var.availability_zone
  vpc_security_group_ids = [ aws_security_group.jenkins.id ]
  user_data = base64encode(file("${path.module}/ssm-agent.sh"))
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.id
  tags = {
    Name = "Master server"
    Jenkins = "Master Jenkins"
  }
}


resource "aws_instance" "slave" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  availability_zone = var.availability_zone
  subnet_id     = var.private_subnet.id 
  vpc_security_group_ids = [ aws_security_group.slave.id ]
  user_data = base64encode(file("${path.module}/ssm-agent.sh"))
  iam_instance_profile = aws_iam_instance_profile.ssm_ec2_profile.id
  
  tags = {
    Name = "Slave server"
  }
}