output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.terraedge_public_subnet[*].id
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = aws_subnet.terraedge_public_subnet[*].cidr_block
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.terraedge_vpc.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.terraedge_private_subnet[*].id
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = aws_subnet.terraedge_private_subnet[*].cidr_block
}
