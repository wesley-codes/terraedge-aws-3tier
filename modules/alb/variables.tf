variable "public_id_subnets" {
  description = "List of subnet IDs to attach to the LB."
  type        = list(string)
}

variable "alb_sg" {
  description = "Security group ID for application load balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}