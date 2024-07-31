resource "aws_iam_user" "aws-iam-users" {
  for_each = toset(var.names)
  name     = "${var.environment}-${each.key}"
}