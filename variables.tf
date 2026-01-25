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