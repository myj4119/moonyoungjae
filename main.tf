#=========== VPC=============
module "main_vpc" {
  source                   = "./vpc"
  main_vpc_cidr            = var.main_vpc_cidr
  default_public_subnet_1  = var.default_public_subnet_1
  default_private_subnet_1 = var.default_private_subnet_1
  default_route_cidr       = var.default_route_cidr
  lo_a                     = var.lo_a

  service_vpc_cidr   = var.service_vpc_cidr
  EKS_public_subnet  = var.EKS_public_subnet
  EKS_private_subnet = var.EKS_private_subnet

  #env = terraform.workspace
}


#============ EC2 ============
module "main_ec2" {
  source                         = "./ec2"
  vpc_id                         = module.main_vpc.vpc_id
  public_subnet_id               = module.main_vpc.public_subnet_ids[0]
  main_ec2_ami                   = var.main_ec2_ami
  main_ec2_instance_type         = var.main_ec2_instance_type
  key_name                       = var.key_name
  main_default_root_block_device = var.main_default_root_block_device
  main_default_ebs_block_device  = var.main_default_ebs_block_device
  main_default_private_ip        = var.main_default_private_ip
  main_default_sg_ingress_rule   = var.main_default_sg_ingress_rule
  main_default_sg_egress_rule    = var.main_default_sg_egress_rule
  lo_a                           = var.lo_a
}


#========= backend 설정 ========= 
resource "aws_s3_bucket" "tf_backend" {
  count  = terraform.workspace == "default" ? 1 : 0 #workspace가 default일 때만 생성이 되고 아니면 고려하지 않는다.
  bucket = "tf-backend-myjtest"


  versioning {
    enabled = true
  }

  #S3 버킷에 기록된 모든 데이터에 서버 측 암호화를 설정한다. (버킷 암호화)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name = "tf_backend"
  }
}

#S3 버킷의 퍼블릭 액세스 설정을 관리
resource "aws_s3_bucket_public_access_block" "tf_backend_block" {
  count                   = terraform.workspace == "default" ? 1 : 0
  bucket                  = aws_s3_bucket.tf_backend[0].id
  block_public_acls       = true #퍼블릭 ACL을 차단
  block_public_policy     = true #퍼블릭 버킷 정책을 차단
  ignore_public_acls      = true #퍼블릭 ACL을 무시하도록 설정
  restrict_public_buckets = true #퍼블릭 버킷 설정을 제한
}

resource "aws_s3_bucket_ownership_controls" "tf_backend_ownership" {
  count  = terraform.workspace == "default" ? 1 : 0
  bucket = aws_s3_bucket.tf_backend[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "tf_backend_acl" {
  count      = terraform.workspace == "default" ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.tf_backend_ownership]

  bucket = aws_s3_bucket.tf_backend[0].id
  acl    = "private"
}
