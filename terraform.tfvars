lo_a = "ap-northeast-2a"
lo_c = "ap-northeast-2c"
#==================== VPC =====================
main_vpc_cidr            = "10.0.0.0/16"
default_public_subnet_1  = "10.0.0.0/24"
default_private_subnet_1 = "10.0.100.0/24"
default_route_cidr       = "0.0.0.0/0"

service_vpc_cidr = "100.0.0.0/16"
EKS_public_subnet = [
  { cidr_block = "100.0.10.0/24", availability_zone = "ap-northeast-2a" },
  { cidr_block = "100.0.20.0/24", availability_zone = "ap-northeast-2c" }
]

EKS_private_subnet = [
  { cidr_block = "100.0.100.0/24", availability_zone = "ap-northeast-2a" },
  { cidr_block = "100.0.200.0/24", availability_zone = "ap-northeast-2c" }
]


#==================== EC2 =====================
main_ec2_ami           = "ami-04c535bac3bf07b9a"
main_ec2_instance_type = "t2.medium"
key_name               = "myj4119"

main_default_root_block_device = [{
  volume_type           = "gp2"
  volume_size           = 20
  delete_on_termination = "true"
}]

main_default_ebs_block_device = [{
  device_name           = "/dev/xvdf"
  volume_type           = "gp2"
  volume_size           = 5
  delete_on_termination = "true"
}]

main_default_private_ip = "10.0.0.10"

main_default_sg_ingress_rule = [
  {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "ALL pass"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    description = "ALL pass"
    from_port   = 41379
    to_port     = 41379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
]

main_default_sg_egress_rule = [
  {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
]
