terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.48.0"
    }
  }

  #backend설정 시 버킷은 하드코딩을 해야한다.
  backend "s3" {
    bucket = "tf-backend-myjtest"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
    #workspace_key_prefix = "temp" #workspace사용 시 tfstate파일이 저장될 객체명 변경
  }

}

provider "aws" {
  region = "ap-northeast-2"
}
