resource "aws_vpc" "terraedge_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraedge-vpc"
  }
}

resource "aws_subnet" "terraedge_public_subnet" {
  vpc_id                  = aws_vpc.terraedge_vpc.id
  count                   = length(var.azs)
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraedge-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "terraedge_private_subnet" {
  vpc_id            = aws_vpc.terraedge_vpc.id
  count             = length(var.azs)
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + var.az_count)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "terraedge-private-subnet-${count.index + 1}"
  }
}
