variable "main_ec2_ami" {}

variable "main_ec2_instance_type" {}

variable "key_name" {}

variable "main_default_root_block_device" {
  description = "root_block_device_value"
  type = list(object({
    volume_type           = string
    volume_size           = number
    delete_on_termination = string
  }))
}

variable "main_default_ebs_block_device" {
  description = "ebs_block_device_value"
  type = list(object({
    device_name           = string
    volume_type           = string
    volume_size           = number
    delete_on_termination = string
  }))
}

variable "main_default_private_ip" {}

variable "main_default_sg_ingress_rule" {
  description = "ingress_value"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "main_default_sg_egress_rule" {
  description = "egress_value"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}


variable "lo_a" {}

variable "public_subnet_id" {
  description = "public서브넷"
  type        = string
}

variable "vpc_id" {
  description = "vpc 아이디"
  type        = string
}

