variable "vpc_id" {
  type        = string
  description = "this is the vpc id"
  default     = "vpc-0cd4f328b70222684"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "subnet" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}

output "all_subnets_list" {
  value = sort([for s in data.aws_subnet.subnet : s.id])
}