output "ec2_ssm_profile_name" {
  value = aws_iam_instance_profile.ec2_ssm_profile.name
}

output "rds_secret_arn" {
  value = var.rds_secret_arn
}


output "lambda_role_name" {
  value = aws_iam_role.lambda_role.name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}


output "s3_bucket_arn" {
  value = "arn:aws:s3:::${var.s3_bucket_name}"
}

output "sns_topic_arn" {
  value = "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:${var.sns_topic_name}"
}

output "sqs_queue_arn" {
  value = "arn:aws:sqs:${var.aws_region}:${var.aws_account_id}:${var.sqs_queue_name}"
}

