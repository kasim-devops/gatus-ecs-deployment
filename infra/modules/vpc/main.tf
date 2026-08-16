resource "aws_vpc" "gatus-deployment-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Gatus VPC"
  }
}
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
resource "aws_subnet" "Private" {
  vpc_id            = aws_vpc.gatus-deployment-vpc.id
  count             = length(var.private_subnet_cidrs)
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zone_names[count.index]

  tags = {
    Name = "private-${count.index}"
  }
}
