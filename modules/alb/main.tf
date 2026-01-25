resource "aws_lb" "terraedge_alb" {
  name                       = "terraedge-lb-tf"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = var.public_id_subnets
  security_groups            = [var.alb_sg]
  enable_deletion_protection = true

  tags = {
    Name = "terraedge-alb"
  }
}