output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "rds_subnet_group" {
  description = "Name of the RDS subnet group"
  value       = aws_db_subnet_group.rds_subnet_group.name # Corrigido para rds_subnet_group
}