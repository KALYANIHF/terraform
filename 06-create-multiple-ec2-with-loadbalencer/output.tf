output "aws-security_group_details" {
  value = aws_security_group.http_server_sg
}

output "ec2-server-instance-details" {
  value = aws_instance.aws_ec2_instance
}