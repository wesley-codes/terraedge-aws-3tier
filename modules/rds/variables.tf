variable "private_subnetID_1" {
  description = "private subnet ID 1"
  type        = string
}

variable "private_subnetID_2" {
  description = "private subnet ID 2"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type        = list(string)
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
