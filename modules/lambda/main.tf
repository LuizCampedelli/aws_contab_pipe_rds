variable "s3_bucket_id" {}

resource "random_id" "unique_id" {
  byte_length = 4
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

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "lambda_secrets_manager_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


resource "aws_s3_object" "lambda_zip" {
  bucket = var.s3_bucket_id
  key    = "lambda.zip"
  source = "lambda.zip"
}

resource "aws_s3_object" "pandas_layer_zip" {
  bucket = var.s3_bucket_id
  key    = "pandas_layer.zip"
  source = "pandas_layer.zip"
}

resource "aws_s3_object" "lambda_dependencies_zip" {
  bucket = var.s3_bucket_id
  key    = "lambda_dependencies.zip"
  source = "lambda_dependencies.zip"
}



resource "aws_lambda_layer_version" "pandas_layer" {
  s3_bucket        = aws_s3_object.pandas_layer_zip.bucket
  s3_key           = aws_s3_object.pandas_layer_zip.key
  layer_name       = "pandas-layer"
  compatible_runtimes = ["python3.8"]
  description      = "A layer that includes pandas library"
  depends_on       = [aws_s3_object.pandas_layer_zip]
}

resource "aws_lambda_layer_version" "lambda_code_layer" {
  s3_bucket        = aws_s3_object.lambda_zip.bucket
  s3_key           = aws_s3_object.lambda_zip.key
  layer_name       = "lambda-code-layer"
  compatible_runtimes = ["python3.8"]
  description      = "A layer for Lambda code"
  depends_on       = [aws_s3_object.lambda_zip]
}



resource "aws_lambda_function" "my_lambda" {
  function_name = "Lambda_process_s3_files"

  s3_bucket = var.s3_bucket_id
  s3_key    = "lambda.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  role    = var.iam_role_arn

  layers = [
    aws_lambda_layer_version.pandas_layer.arn,
    aws_lambda_layer_version.lambda_code_layer.arn
  ]

  environment {
    variables = {
      RDS_ENDPOINT = var.rds_endpoint
      RDS_PORT     = var.rds_port
      RDS_USER     = var.rds_user
      RDS_PASSWORD = var.rds_password
      RDS_DBNAME   = var.rds_dbname
    }
  }
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_trigger]
}

resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_bucket_id}"
}
