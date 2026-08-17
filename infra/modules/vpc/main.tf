# VPC
resource "aws_vpc" "gatus-deployment-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Gatus VPC"
  }
}

# Public Subnets
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.gatus-deployment-vpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zone_names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${count.index}"
  }
}

# Private Subnets
resource "aws_subnet" "Private" {
  vpc_id            = aws_vpc.gatus-deployment-vpc.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone_names[count.index]

  tags = {
    Name = "private-${count.index}"
  }
}

# Internet Gateway
  resource "aws_internet_gateway" "gatus-ig" {
  vpc_id = aws_vpc.gatus-deployment-vpc.id

  tags = {
    Name = "gatus-ig"
  }
}

# Elastic IP Allocation
resource "aws_eip" "natgw-eip" {
  domain = "vpc"
}

# NAT Gateway
resource "aws_nat_gateway" "gatus-natgw" {
  allocation_id = aws_eip.natgw-eip.id
  subnet_id     = aws_subnet.Public[0].id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gatus-ig]
}

# Route tables

# Public Route Table
resource "aws_route_table" "gatus-public-rt" {
  vpc_id = aws_vpc.gatus-deployment-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gatus-ig.id
    }
    tags = {
      Name = "PublicRoute"
  }
}

  # Private Route Table
  resource "aws_route_table" "gatus-private-rt" {
    vpc_id = aws_vpc.gatus-deployment-vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.gatus-natgw.id
      }
      tags = {
        Name = "PrivateRoute"
    }
  }

  # Route Table Associations
  # Public Route Table Associations
  resource "aws_route_table_association" "gatus-public-rt" {
    count         = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.gatus-public-rt.id
}
# Private Route Table Associations
resource "aws_route_table_association" "gatus-private-rt" {
  count         = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.Private[count.index].id
  route_table_id = aws_route_table.gatus-private-rt.id
}
