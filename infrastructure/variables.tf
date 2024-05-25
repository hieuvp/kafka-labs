variable "aws_profile" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_name" {}

variable "instance_tags" {
  default = {}
}

variable "instance_ami" {
  default = "ami-0bb84b8ffd87024d8"
}

variable "instance_type" {
  # https://aws.amazon.com/ec2/instance-types/t2/
  default = "t2.large"
}

variable "instance_volume_size" {
  default = "30"
}

variable "associate_public_ip_address" {
  default = false
}

variable "instance_subnet_id" {}

variable "instance_security_group_ids" {
  default = []
}

variable "instance_username" {
  default = "ec2-user"
}

variable "instance_key_name" {}

variable "instance_key_file" {}
