variable "aws_profile" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "instance_name" {}

variable "instance_tags" {
  default = {}
}

variable "instance_ami" {
  default = "ami-07caf09b362be10b8"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_volume_size" {
  default = "30"
}

variable "instance_subnet_id" {}

variable "instance_security_group_ids" {
  default = []
}

variable "instance_key_name" {}
