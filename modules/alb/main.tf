resource "aws_lb" "terraedge_alb" {
  name                       = "terraedge-lb-tf"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_id_subnets
  security_groups            = [var.alb_sg]
  enable_deletion_protection = false

  tags = {
    Name = "terraedge-alb"
  }
}

# Target group for the ALB
resource "aws_lb_target_group" "terraedge_tg" {
  name     = "terraedge-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    matcher             = "200"
  }

  tags = {
    Name = "terraedge-tg"
  }
}

# ALB Listener
resource "aws_lb_listener" "terraedge_listener" {
  load_balancer_arn = aws_lb.terraedge_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraedge_tg.arn
  }
}