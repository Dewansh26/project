variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "key-name" {
  description = "SSH Key Name"
  type        = string
}

variable "network-security-group-name" {
 description = "Security Group Name"
 type        = string
}

variable "ubuntu-ami" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "ubuntu-instance-type" {
  description = "Ubuntu Instance Type"
  type        = string
}
