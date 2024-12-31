provider "aws" {
  region = "ap-south-1"  # Replace with your preferred AWS region
}

# Security group to allow inbound traffic on ports 22 (SSH), 80 (HTTP), and 443 (HTTPS)
resource "aws_security_group" "allow_http_ssh_https" {
  name        = "allow-http-ssh-https"
  description = "Allow inbound HTTP, HTTPS, and SSH traffic"

  # Allow SSH on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS on port 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2 instance configuration
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-03c68e52484d7488f"  # Replace with your chosen AMI ID
  instance_type = "t2.micro"                # Change to your desired instance type
  key_name      = "jenkins"                 # Replace with your existing key pair name

 # security_groups = [aws_security_group.allow_http_ssh_https.name]
	vpc_security_group_ids = ["sg-08be20afe6dcfc3bb"]  # Replace sg-xxxxxxxx with your existing Security Group ID
  tags = {
    Name = "MyEC2Instance"
  }

  # Enable detailed monitoring (optional)
  monitoring = true
}

# Output the public IP address of the created EC2 instance
output "instance_public_ip" {
  value = aws_instance.my_ec2_instance.public_ip
}
