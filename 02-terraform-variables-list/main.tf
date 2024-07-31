variable "names" {
  type    = list(string)
  default = ["alpha","souvik", "John", "Meland", "Jupiter"]
}

variable "environment" {
  type    = string
  default = "dev"
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

