variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "rds_password" {
  description = "Password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "rds_user" {
  description = "The username for the RDS instance"
  type        = string
}

variable "rds_dbname" {
  description = "The database name of the RDS instance"
  type        = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "sqs_queue_arn" {
  type = string
}


variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "sns_topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "sqs_queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}


variable "secrets_manager_secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  type        = string
}

variable "rds_secret_arn" {
  description = "The ARN of the RDS Secrets Manager secret"
  type        = string
}
