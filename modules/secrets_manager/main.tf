resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric  = true
}

resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds_password_${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "rds_credentials_${random_string.suffix.result}"
}

resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    username = var.rds_username
    password = var.rds_password
  })
}
