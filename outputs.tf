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

output "target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_group_arn
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
  count = length(module.vpc.public_subnet_ids)
  id    = module.vpc.public_subnet_ids[count.index]
}

data "aws_subnet" "private_subnets" {
  count = length(module.vpc.private_subnet_ids)
  id    = module.vpc.private_subnet_ids[count.index]
}

data "aws_instances" "app_asg_instances" {
  filter {
    name   = "tag:Name"
    values = ["terraedge-app"]
  }

  filter {
    name   = "instance-state-name"
    values = ["pending", "running", "stopping", "stopped"]
  }
}

data "aws_instance" "app_asg_instance" {
  for_each    = toset(data.aws_instances.app_asg_instances.ids)
  instance_id = each.value
}

output "private_subnet_azs" {
  description = "AZs for private subnets used by the EC2 ASG"
  value = zipmap(
    module.vpc.private_subnet_ids,
    [for subnet in data.aws_subnet.private_subnets : subnet.availability_zone]
  )
}

output "public_subnet_azs" {
  description = "AZs for public subnets used by the EC2 ASG"
  value = zipmap(
    module.vpc.public_subnet_ids,
    [for subnet in data.aws_subnet.public_subnets : subnet.availability_zone]
  )
}

output "ec2_asg_subnet_ids" {
  description = "Subnet IDs where EC2 ASG instances are launched"
  value       = module.vpc.public_subnet_ids
}

output "ec2_asg_subnet_azs" {
  description = "Subnet IDs to AZs map for EC2 ASG instances"
  value = zipmap(
    module.vpc.public_subnet_ids,
    [for subnet in data.aws_subnet.public_subnets : subnet.availability_zone]
  )
}

output "asg_ec2_details" {
  description = "EC2 instances with subnet, AZ, and IPs (filtered by Name tag)"
  value = {
    for id, instance in data.aws_instance.app_asg_instance :
    id => {
      instance_id       = instance.id
      subnet_id         = instance.subnet_id
      availability_zone = instance.availability_zone
      private_ip        = instance.private_ip
      public_ip         = instance.public_ip
      instance_state    = instance.instance_state
    }
  }
}
