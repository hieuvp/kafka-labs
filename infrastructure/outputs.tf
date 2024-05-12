output "kafka_private_ip" {
  value = aws_instance.kafka.private_ip
}

output "kafka_public_ip" {
  value = aws_instance.kafka.public_ip
}

output "kafka_ssh_username" {
  value = var.instance_username
}

output "kafka_ssh_key_file" {
  value = var.instance_key_file
}
