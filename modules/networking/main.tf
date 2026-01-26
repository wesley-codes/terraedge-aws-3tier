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

# Internet Gateway for public subnets (required for internet-facing ALB)
resource "aws_internet_gateway" "terraedge_gw" {
  vpc_id = aws_vpc.terraedge_vpc.id

  tags = {
    Name = "terraedge_gw"
  }
}

resource "aws_route_table" "terraedge_route_table" {
  vpc_id = aws_vpc.terraedge_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraedge_gw.id
  }

  tags = {
    Name = "terraedge-route-table"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "terraedge_public_rta" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.terraedge_public_subnet[count.index].id
  route_table_id = aws_route_table.terraedge_route_table.id
}