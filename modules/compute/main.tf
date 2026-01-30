data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "terraedge-app"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.app_sg_id]

  user_data = base64encode(file("${path.module}/scripts/user-data.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraedge-app"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "terraedge-app-asg"
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = "ELB"
  health_check_grace_period = 60
  vpc_zone_identifier       = var.public_subnet_ids
  target_group_arns         = [var.alb_target_group_arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraedge-app"
    propagate_at_launch = true
  }
}
