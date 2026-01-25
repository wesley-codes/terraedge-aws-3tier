variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones to use for subnets"
}

variable "az_count" {
  type        = number
  description = "Number of Availability Zones to use"
  default     = 2
}