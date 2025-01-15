#========================== 인스턴스 생성 ==========================
resource "aws_instance" "default_main_ec2" {
  ami                                  = var.main_ec2_ami
  instance_type                        = var.main_ec2_instance_type
  availability_zone                    = var.lo_a
  key_name                             = var.key_name
  monitoring                           = false
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"

  network_interface {
    network_interface_id = aws_network_interface.default_ec2_nic.id
    device_index         = 0
  }

  root_block_device {
    volume_type           = var.main_default_root_block_device[0].volume_type
    volume_size           = var.main_default_root_block_device[0].volume_size
    delete_on_termination = var.main_default_root_block_device[0].delete_on_termination
  }

  ebs_block_device {
    device_name           = var.main_default_ebs_block_device[0].device_name
    volume_type           = var.main_default_ebs_block_device[0].volume_type
    volume_size           = var.main_default_ebs_block_device[0].volume_size
    delete_on_termination = var.main_default_ebs_block_device[0].delete_on_termination
  }

  tags = {
    Name = "default_ec2"
  }
}


#========================== eip 생성 ==========================
resource "aws_eip" "instance_eip" {
  instance                  = null
  network_interface         = aws_network_interface.default_ec2_nic.id
  associate_with_private_ip = var.main_default_private_ip

  tags = {
    Name = "default_eip"
  }
}


#========================== 네트워크 인터페이스 생성 ==========================
resource "aws_network_interface" "default_ec2_nic" {
  subnet_id       = var.public_subnet_id
  private_ips     = [var.main_default_private_ip]
  security_groups = [aws_security_group.default_main_sg.id]

  tags = {
    Name = "default_ec2_nic"
  }
}


#========================== 보안그룹 생성 ==========================
resource "aws_security_group" "default_main_sg" {
  name_prefix = "default_main_sg"
  description = "Allow inbound SSH and outbound internet access"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.main_default_sg_ingress_rule
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.main_default_sg_egress_rule
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "default_main_sg"
  }
}
