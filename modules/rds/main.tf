resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name                 = "meudb1182001"
  username             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  password = random_password.rds_password.result
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}
