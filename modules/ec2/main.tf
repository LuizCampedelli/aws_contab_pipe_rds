# modules/ec2/main.tf

variable "subnet_id" {}
variable "vpc_id" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name   = "my-ssh-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "private_key_pem" {
  filename = "${path.module}/my-ssh-key.pem"
  content  = tls_private_key.ssh.private_key_pem
  file_permission = "400"
}


resource "aws_security_group" "web" {
  name        = "allow-ssh-and-http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
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
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.ssh.key_name
  iam_instance_profile   = var.iam_instance_profile_name

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo dnf install -y mariadb105
              EOF

  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}
