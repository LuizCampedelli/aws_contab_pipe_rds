variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
  default     = "thebucket"
}

variable "bucket_suffix" {
  description = "Suffix for the S3 bucket name"
  type        = string
  default     = "1182001"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

