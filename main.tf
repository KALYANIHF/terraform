terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67"
    }
  }
}
 
# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
  # VERSION IS NOT NEEDED HERE
}

resource "aws_s3_bucket" "my_s3_bucket_001" {
  bucket = "my-s3-bucketsouvik-002"

  versioning {
    enabled = true
  }
}

resource "aws_iam_user" "my-iam-user-souvik-001" {
  name = "my-iam-user-souvik-updated"
}

output "my_s3_bucket_001_version" {
  value = aws_s3_bucket.my_s3_bucket_001.versioning[0].enabled
}

output "my_s3_bucket_001_details" {
  value = aws_s3_bucket.my_s3_bucket_001
}

