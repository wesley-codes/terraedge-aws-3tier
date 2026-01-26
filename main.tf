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