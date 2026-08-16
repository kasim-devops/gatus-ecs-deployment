output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.gatus-deployment-vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.Public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.Private[*].id
}