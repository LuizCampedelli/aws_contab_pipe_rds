provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc-1182001"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-vpc-igw-1182001"
  }
}

# Subnets Públicas
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = "us-east-1${count.index}"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# Subnets Privadas
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = "us-east-1${count.index}"

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# Subnet Group para RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "RDS Subnet Group"
  }
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# EC2 Instance
resource "aws_instance" "web" {
  ami           = "ami-085925f297f89fce1" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.web.id] # Você precisa definir este security group

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpie
              EOF

  tags = {
    Name = "Web Server with HTTPie"
  }
}

# Security Group para EC2
resource "aws_security_group" "web" {
  name        = "allow_httpie"
  description = "Allow HTTPie for RDS access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric  = true
  special = false
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mybucket${random_string.bucket_suffix.result}1182001"
}

resource "null_resource" "upload_lambda" {
  provisioner "local-exec" {
    command = "aws s3 cp lambda.zip s3://${aws_s3_bucket.my_bucket.bucket}/lambda.zip"
  }

  depends_on = [aws_s3_bucket.my_bucket]
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "Lambda_process_s3_files"

  s3_bucket = aws_s3_bucket.my_bucket.bucket
  s3_key    = "lambda.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CACHE_URL = "http://elasticache-url"  # Defina a URL correta do seu ElastiCache
    }
  }

  depends_on = [null_resource.upload_lambda]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid = ""
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
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.my_bucket.arn,
          "${aws_s3_bucket.my_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "sns:Publish"
        ],
        Resource = aws_sns_topic.my_topic.arn
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage"
        ],
        Resource = aws_sqs_queue.my_queue.arn
      },
      {
        Effect = "Allow",
        Action = [
          "elasticache:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "meudb1182001"
  username             = "admin"
  password             = "sua_senha_muito_segura_e_indestrutivel"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_sns_topic" "my_topic" {
  name = "my_topic_1182001"
}

resource "aws_sqs_queue" "my_queue" {
  name = "my_queue_1182001"
}

output "s3_bucket" {
  value = aws_s3_bucket.my_bucket.bucket
}
