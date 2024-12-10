output "topic_arn" {
  value       = aws_sns_topic.data_notification.arn
  description = "The ARN of the SNS topic"
}
