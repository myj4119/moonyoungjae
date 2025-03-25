variable "env" {
  type    = string
  default = "default"
}
variable "main_vpc_cidr" {}
variable "default_public_subnet_1" {}
variable "default_private_subnet_1" {}
variable "default_route_cidr" {}
variable "lo_a" {}


variable "service_vpc_cidr" {}
variable "EKS_public_subnet" {}
variable "EKS_private_subnet" {}
