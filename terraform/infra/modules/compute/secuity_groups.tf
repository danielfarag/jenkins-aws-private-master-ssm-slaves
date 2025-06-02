resource "aws_security_group" "nginx" {
  name        = "nginx_server"
  vpc_id = var.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks =   [ "0.0.0.0/0" ]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks =   [ "0.0.0.0/0" ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks =   [ "0.0.0.0/0" ]
  }

  tags = {
    Name = "COnfigure Nginx Server"
  }
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins_server"
  vpc_id = var.vpc.id
  
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [ aws_security_group.nginx.id, aws_security_group.slave.id ]
  }

  ingress {
    from_port       = 50000
    to_port         = 50000
    protocol        = "tcp"
    security_groups = [ aws_security_group.nginx.id ]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks =   [ "0.0.0.0/0" ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     =  ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins Master Server"
  }
}


resource "aws_security_group" "slave" {
  name        = "jenkins_slave"
  vpc_id = var.vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     =  ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks =   [ "0.0.0.0/0" ]
  }


  tags = {
    Name = "Jenkins Slave Server"
  }
}