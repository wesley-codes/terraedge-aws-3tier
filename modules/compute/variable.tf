variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ASG"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "Target group ARN to attach instances to"
  type        = string
}

variable "app_sg_id" {
  description = "Security group ID for the app instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}
