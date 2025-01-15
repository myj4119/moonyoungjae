output "default_main_ec2" {
  value = aws_instance.default_main_ec2.id
}

output "default_ec2_nic" {
  value = aws_network_interface.default_ec2_nic.id
}
