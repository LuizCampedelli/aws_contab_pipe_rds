resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  lower   = true
  numeric  = true
  special = false
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_prefix}${random_string.bucket_suffix.result}${var.bucket_suffix}"
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}
