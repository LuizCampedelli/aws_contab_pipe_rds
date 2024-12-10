output "rds_secret_arn" {
  value = aws_secretsmanager_secret.rds_credentials.arn
}

output "rds_password_name" {
  value = aws_secretsmanager_secret.rds_password.name
}
