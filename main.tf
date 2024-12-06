provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"
  subnet_id = module.vpc.public_subnets[0]
  vpc_id    = module.vpc.vpc_id
}

module "s3" {
  source = "./modules/s3"
}

module "lambda" {
  source       = "./modules/lambda"
  s3_bucket_id = module.s3.bucket_id
  s3_bucket_arn  = module.s3.bucket_arn
  rds_endpoint = module.rds.endpoint
  rds_port     = module.rds.port
  sns_topic_arn  = module.sns.topic_arn
  sqs_queue_arn  = module.sqs.queue_arn
}

module "rds" {
  source        = "./modules/rds"
  subnet_group  = module.vpc.rds_subnet_group
  vpc_id        = module.vpc.vpc_id
}

module "sns" {
  source = "./modules/sns"
}

module "sqs" {
  source = "./modules/sqs"
}
