provider "aws" {
  region     = "ap-south-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_vpc" "A" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "Dewansh"
  }
}

resource "aws_internet_gateway" "GW_Dewansh" {
  vpc_id = aws_vpc.A.id

  tags = {
    Name = "IG_Dewansh"
  }
}

resource "aws_route_table" "RT_Dewansh" {
  vpc_id = aws_vpc.A.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GW_Dewansh.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.GW_Dewansh.id
  }

  tags = {
    Name = "RT_Dewansh"
  }
}

resource "aws_subnet" "Subnet_Dewansh" {
  vpc_id            = aws_vpc.A.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  depends_on        = [aws_internet_gateway.GW_Dewansh]

  tags = {
    Name = "Subnet_Dewansh"
  }
}

resource "aws_route_table_association" "RT_to_Subnet" {
  subnet_id      = aws_subnet.Subnet_Dewansh.id
  route_table_id = aws_route_table.RT_Dewansh.id
}

resource "aws_security_group" "SG_Dewansh" {
  name        = "SG_Dewansh"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = aws_vpc.A.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "SG_Dewansh"
  }
}

resource "aws_network_interface" "ENI_A" {
  subnet_id       = aws_subnet.Subnet_Dewansh.id
  private_ips     = ["10.0.0.10"]
  security_groups = [aws_security_group.SG_Dewansh.id]
}

resource "aws_eip" "EIP_A" {
  vpc                       = true
  network_interface         = aws_network_interface.ENI_A.id
  associate_with_private_ip = "10.0.0.10"
  depends_on                = [aws_internet_gateway.GW_Dewansh, aws_instance.Instance_A]

  tags = {
    Name = "EIP_A"
  }
}

resource "aws_instance" "Instance_A" {
  ami               = "ami-03c68e52484d7488f"
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  key_name          = "vpc"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.ENI_A.id
  }

  tags = {
    Name = "Dewansh_1.0"
  }
}
