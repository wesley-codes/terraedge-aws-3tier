output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = module.vpc.public_subnet_cidrs
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = module.vpc.private_subnet_cidrs
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}

output "rds_writer" {
  description = "Writer RDS instance identifiers and AZ"
  value       = module.rds.writer_info
}

output "rds_reader" {
  description = "Reader RDS instance identifiers and AZ"
  value       = module.rds.reader_info
}

output "rds_writer_subnet" {
  description = "Writer subnet id and AZ"
  value       = module.rds.writer_subnet_info
}

output "rds_reader_subnet" {
  description = "Reader subnet id and AZ"
  value       = module.rds.reader_subnet_info
}

data "aws_subnet" "public_subnets" {
  for_each = toset(module.vpc.public_subnet_ids)
  id       = each.value
}

data "aws_subnet" "private_subnets" {
  for_each = toset(module.vpc.private_subnet_ids)
  id       = each.value
}

output "private_subnet_azs" {
  description = "AZs for private subnets used by the EC2 ASG"
  value = {
    for id, subnet in data.aws_subnet.private_subnets :
    id => subnet.availability_zone
  
  }
}


output "public_subnet_azs" {
  description = "AZs for public subnets used by the EC2 ASG"
  value = {
    for id, subnet in data.aws_subnet.public_subnets :
    id => subnet.availability_zone
  }
}
