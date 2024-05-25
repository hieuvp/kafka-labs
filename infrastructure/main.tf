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
}

resource "local_file" "hosts" {
  content = templatefile("hosts.yml", {
    kafka_ip_address = aws_instance.kafka.private_ip
    ssh_username     = var.instance_username
    ssh_key_file     = var.instance_key_file
  })

  filename = "${path.module}/hosts_rendered.yml"
}

resource "null_resource" "ansible" {

  connection {
    type        = "ssh"
    host        = aws_instance.kafka.private_ip
    user        = var.instance_username
    private_key = file(var.instance_key_file)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf -y update",
      "sudo dnf -y install python3.11",
      "sudo dnf -y install python3.11-pip",
      "pip3.11 install pipx",
      "pipx install --force --include-deps ansible==9.5.1 --python python3.11",
    ]
  }
}
