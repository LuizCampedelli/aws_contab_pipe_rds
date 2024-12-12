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

variable "private_subnet_ids" {
  type = list(string)
}

variable "rds_subnet_group" {
  type = object({
    name = string
  })
  description = "RDS subnet group"
  default = {
    name = "default-rds-subnet-group"
  }
}
variable "rds_subnet_group_name" {
  type        = string
  description = "Name of the RDS subnet group"
}
