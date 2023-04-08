terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.58.0"
    }
  }

  backend "s3" {
    bucket  = "terraform-backend-353981446712" #手動で作成したterraform バックエンド用のS3バケット名
    region  = "ap-northeast-1"
    key     = "AWS_ContainerDesignDev_Book_MyCodes_tfstateFile/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Managed   = "terraform"
      Reference = "aws_continer_design_dev"
    }
  }
}
