data "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnet-group"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "meudb1182001"
  username             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  password = random_password.rds_password.result

  # Associate with the security group and subnet group
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = var.rds_subnet_group_name
}

resource "random_password" "rds_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow inbound traffic for MySQL"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
