provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "mikhail_flask_app" {
  ami = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = "mikhail-east1" 
  vpc_security_group_ids = [aws_security_group.mikhail_flask_sg.id]

  tags = {
    Name = "mikhail_flaskApp"
  }

  root_block_device {
    volume_size = 20  # Increased for MySQL and application data
  }
}

resource "aws_security_group" "mikhail_flask_sg" {
  name_prefix = "flask-sg"
  description = "Security group for Flask application"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask application access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "flask-security-group"
  }
}

output "ec2_public_ip" {
  value = aws_instance.mikhail_flask_app.public_ip
  description = "Public IP of the Flask application server"
}

output "ec2_public_dns" {
  value = aws_instance.mikhail_flask_app.public_dns
  description = "Public DNS of the Flask application server"
}