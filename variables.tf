# VPC Variables
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to use"
  default     = 2
}

# Compute / ASG variables
variable "instance_type" {
  description = "EC2 instance type for the ASG"
  type        = string
  default     = "t3.micro"
}


variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 2
}


variable "db_username" {
  description = "Username of db"
  type        = string
}

variable "db_passwd" {
  description = "passwd of db"
  type        = string
  validation {
    condition     = length(var.db_passwd) >= 8
    error_message = "db_passwd must be at least 8 characters."
  }
}
