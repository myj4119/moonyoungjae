output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet_1[*].id
}


output "EKS_vpc_id" {
  value = aws_vpc.service_vpc.id
}

output "EKS_public_subnet_ids" {
  value = aws_subnet.EKS_public_subnet[*].id
}

output "EKS_private_subnet_ids" {
  value = aws_subnet.EKS_private_subnet[*].id
}
