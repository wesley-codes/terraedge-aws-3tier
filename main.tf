data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source         = "./modules/networking"
  vpc_cidr_block = var.vpc_cidr_block
  azs            = local.azs
  az_count       = var.az_count

}

module "alb" {
  source            = "./modules/alb"
  public_id_subnets = module.vpc.public_subnet_ids
  alb_sg            = module.security.alb_security_group_id
  vpc_id            = module.vpc.vpc_id
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id

}

module "compute" {
  source               = "./modules/compute"
  public_subnet_ids    = module.vpc.public_subnet_ids
  alb_target_group_arn = module.alb.target_group_arn
  app_sg_id            = module.security.app_security_group_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  desired_capacity     = var.desired_capacity
  min_size             = var.min_size
  max_size             = var.max_size
}
