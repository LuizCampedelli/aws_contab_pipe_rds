# modules/lambda/variables.tf

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic"
}

variable "sqs_queue_arn" {
  description = "The ARN of the SQS queue"
}
