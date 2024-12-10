variable "ami" {
  default = "ami-085925f297f89fce1"
  type = string
}

variable "instance_type" {
  default = "t2.micro"
  type = string
}

variable "instance_name" {
  default = "Web Server with HTTPie"
  type = string
}

variable "rds_secret_arn" {
  description = "The ARN of the RDS secret"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile"
  type        = string
}
