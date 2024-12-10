
module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source    = "./modules/ec2"
  ami       = "ami-0453ec754f44f9a4a"
  subnet_id = module.vpc.public_subnets[0]
  vpc_id    = module.vpc.vpc_id
  rds_secret_arn = module.secrets_manager.rds_secret_arn
  iam_instance_profile_name = module.iam.ec2_ssm_profile_name
}

module "s3" {
  source = "./modules/s3"
  bucket_name = "my-lambda-layer-bucket"
}

module "lambda" {
  source       = "./modules/lambda"
  s3_bucket_id = module.s3.bucket_id
  s3_bucket_arn  = module.s3.bucket_arn
  s3_bucket_name = module.s3.bucket_name
  rds_endpoint = module.rds.endpoint
  rds_port     = module.rds.port
  rds_user     = var.rds_user
  rds_password = var.rds_password
  rds_dbname   = var.rds_dbname
  sns_topic_arn  = module.sns.topic_arn
  sqs_queue_arn  = module.sqs.queue_arn
  secrets_manager_secret_arn = var.secrets_manager_secret_arn
  iam_role_arn = module.iam.lambda_role_arn
}

module "rds" {
  source        = "./modules/rds"
  subnet_group  = module.vpc.rds_subnet_group
  vpc_id        = module.vpc.vpc_id
  rds_password = var.rds_password
}

module "sns" {
  source = "./modules/sns"
}

module "sqs" {
  source = "./modules/sqs"
}

module "secrets_manager" {
  source = "./modules/secrets_manager"
  rds_username = "admin"
  rds_password = ""
}

module "iam" {
  source = "./modules/iam"
  s3_bucket_name             = var.s3_bucket_name
  sns_topic_name             = var.sns_topic_name
  sqs_queue_name             = var.sqs_queue_name
  secrets_manager_secret_arn = var.secrets_manager_secret_arn
  rds_secret_arn             = var.rds_secret_arn
  aws_account_id             = var.aws_account_id
  aws_region                 = var.aws_region
}
