resource "aws_instance" "kafka" {
  ami = var.instance_ami

  instance_type = var.instance_type
  root_block_device {
    volume_size = var.instance_volume_size
  }

  associate_public_ip_address = false
  subnet_id                   = var.instance_subnet_id
  vpc_security_group_ids      = var.instance_security_group_ids
  key_name                    = var.instance_key_name

  tags = merge(var.instance_tags, {
    Name = var.instance_name
  })
}
