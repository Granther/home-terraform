provider "aws" {
  region = "us-east-2" # Replace with your desired AWS region
}

# Generate a key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Security group allowing SSH access
resource "aws_security_group" "pavlov_ingress" {
  name        = "pavlov_ingress"
  description = "SSH and Pavlov Ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP/CIDR for better security
  }

  ingress {
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP/CIDR for better security
  }

  ingress {
    from_port   = 8177
    to_port     = 8177
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with specific IP/CIDR for better security
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["104.1.220.133/32"] # Replace with specific IP/CIDR for better security
  }

  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "udp"
    cidr_blocks = ["104.1.220.133/32"] # Replace with specific IP/CIDR for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pavlov_ec2" {
  ami = "ami-036841078a4b68e14"
  instance_type = "t2.large"

  key_name = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.pavlov_ingress.name]

  root_block_device {
    volume_size = 32
    volume_type = "gp3"
  }

  tags = {
    Name = "Pavlov"
  }
}

# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.ec2_key.private_key_pem
  filename = "${path.module}/ec2-key.pem"
}

output "instance_public_ip" {
  value = aws_instance.pavlov_ec2.public_ip
}
