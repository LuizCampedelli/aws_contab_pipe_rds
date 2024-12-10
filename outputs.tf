output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "rds_subnet_group" {
  value = module.vpc.rds_subnet_group
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}

output "s3_bucket_arn" {
  value = module.s3.bucket_arn
}

output "lambda_function_name" {
  value = module.lambda.function_name
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "rds_port" {
  value = module.rds.port
}

output "sns_topic_arn" {
  value = module.sns.topic_arn
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "rds_secret_arn" {
  value = module.secrets_manager.rds_secret_arn
}
