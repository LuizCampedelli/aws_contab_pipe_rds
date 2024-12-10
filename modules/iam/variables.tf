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

variable "secrets_manager_secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  type        = string
}

variable "rds_secret_arn" {
  description = "The ARN of the RDS Secrets Manager secret"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1" # Update as needed
}

