variable "region" {
  default = "us-east-1"
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}
