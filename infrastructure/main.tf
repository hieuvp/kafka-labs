resource "aws_instance" "kafka" {
  ami = var.instance_ami

  instance_type = var.instance_type
  root_block_device {
    volume_size = var.instance_volume_size
  }

  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = var.instance_subnet_id
  vpc_security_group_ids      = var.instance_security_group_ids
  key_name                    = var.instance_key_name

  tags = merge(var.instance_tags, {
    Name = var.instance_name
  })

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = var.instance_username
    private_key = file(var.instance_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y update",
      "sudo yum -y install ansible",
    ]
  }
}

resource "local_file" "hosts" {
  content = templatefile("hosts.yml", {
    kafka_ip_address = aws_instance.kafka.private_ip
    ssh_username     = var.instance_username
    ssh_key_file     = var.instance_key_file
  })

  filename = "${path.module}/hosts_rendered.yml"
}
