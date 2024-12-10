variable "subnet_group" {}
variable "vpc_id" {}

output "endpoint" {
  value = aws_db_instance.default.endpoint
}

output "port" {
  value = aws_db_instance.default.port
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}
