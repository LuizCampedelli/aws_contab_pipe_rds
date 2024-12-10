locals {
  s3_bucket_arn = "arn:aws:s3:::${var.s3_bucket_name}"
  s3_bucket_objects_arn = "${local.s3_bucket_arn}/*"
}

resource "random_id" "unique_id" {
  byte_length = 4
}


resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role_${random_id.unique_id.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}


resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "IAM policy for Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # S3 permissions
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          local.s3_bucket_arn,
          local.s3_bucket_objects_arn
        ]
      },
      # SNS permissions
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = format("arn:aws:sns:%s:%s:%s", var.aws_region, var.aws_account_id, var.sns_topic_name)
      },
      # SQS permissions
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ]
        Resource = format("arn:aws:sqs:%s:%s:%s", var.aws_region, var.aws_account_id, var.sqs_queue_name)
      },
      # RDS permissions
      {
        Effect = "Allow"
        Action = [
          "rds:DescribeDBInstances",
          "rds:DescribeDBClusters",
          "rds-data:*"
        ]
        Resource = "*"  # Allow all RDS resources
      }
    ]
  })
}




resource "aws_iam_policy" "secrets_manager_access" {
  name        = "SecretsManagerAccessPolicy"
  description = "IAM policy for accessing Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.secrets_manager_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "lambda_secrets_manager_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_secrets_policy" {
  name        = "SSMSecretsAccess"
  description = "Policy to allow access to Secrets Manager"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.rds_secret_arn  # Secrets Manager ARN
      }
    ]
  })
}



resource "aws_iam_role_policy_attachment" "attach_ssm_secrets_policy" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_secrets_policy.arn
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2_ssm_profile"
  role = aws_iam_role.ec2_ssm_role.name
}
