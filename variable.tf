variable "lo_a" {}

#==================== VPC ====================
variable "main_vpc_cidr" {}
variable "default_public_subnet_1" {}
variable "default_private_subnet_1" {}
variable "default_route_cidr" {}


#=================== EC2 =====================
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

