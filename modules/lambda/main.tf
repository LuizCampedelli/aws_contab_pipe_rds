variable "s3_bucket_id" {}

resource "null_resource" "upload_lambda" {
  provisioner "local-exec" {
    command = "aws s3 cp lambda.zip s3://${var.s3_bucket_id}/lambda.zip"
  }
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "Lambda_process_s3_files"

  s3_bucket = var.s3_bucket_id
  s3_key    = "lambda.zip"

  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      CACHE_URL = var.cache_url
    }
  }

  depends_on = [null_resource.upload_lambda]
}
