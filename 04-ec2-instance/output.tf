output "aws_security_group_details" {
    value = aws_security_group.http_server_sg
}

output "aws_server_info" {
    value = aws_instance.aws_ec2_instance
}

output "aws-public-dns" {
    value = aws_instance.aws_ec2_instance.public_dns
}