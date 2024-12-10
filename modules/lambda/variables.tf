variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic"
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
}

variable "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  type        = string
}

variable "rds_port" {
  description = "The port number of the RDS instance"
  type        = string
}

variable "rds_user" {
  description = "The username for the RDS instance"
  type        = string
}

variable "rds_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "rds_dbname" {
  description = "The database name of the RDS instance"
  type        = string
}

variable "secrets_manager_secret_arn" {
  description = "ARN of the Secrets Manager secret"
  type        = string
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role to assign to the Lambda function."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store the Lambda layer"
  type        = string
}

