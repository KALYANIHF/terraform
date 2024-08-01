variable "aws_key_pair" {
  default = "~/aws/aws_keys/default-ec2.pem"
}

resource "aws_default_vpc" "aws_get_default_vpc" {

}

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

resource "aws_security_group" "http_server_sg" {
  name = "http_server_security_group"
  #   vpc_id      = "vpc-06d1b2b9c0c5e7dfc"
  vpc_id      = aws_default_vpc.aws_get_default_vpc.id
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    name = "http_server_sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.http_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.http_server_sg.id
  ip_protocol       = "tcp"
  cidr_ipv6         = "::/0"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.http_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" // semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.http_server_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "aws_ec2_instance" {
  ami                    = "ami-0648742c7600c103f"
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  availability_zone      = "us-west-2"
  for_each               = data.aws_subnet.subnet
  subnet_id              = each.value.id

  tags = {
    name = "${each.key}-http-server-information"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }
}

output "aws_default_vpc" {
  value = aws_default_vpc.aws_get_default_vpc
}