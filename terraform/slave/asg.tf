resource "aws_launch_template" "slave_launch_template" {
  name_prefix   = "jenkins-slave-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.ami_type
  user_data     = base64encode(file("${path.module}/jenkins_slave.sh"))

  iam_instance_profile {
    name = var.iam_profile_name
  }

  vpc_security_group_ids = [var.slave_sg]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "Slave server"
      Group   = "Group1"
      Jenkins = "Slave"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "slave_asg" {
  name                      = "jenkins-slave-asg"
  max_size                  = 3
  min_size                  = 2
  desired_capacity          = 2

  launch_template {
    id      = aws_launch_template.slave_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = [var.private_subnet]
}