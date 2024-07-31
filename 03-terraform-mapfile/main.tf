variable "users" {
  default = {
    souvik01 : { country : "india", department : "Finance" }
    tom : { country : "US", department : "development" }
    jane : { country : "Netherlands", department : "Design" }
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "aws-iam-users" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
    department : each.value.department
  }
}