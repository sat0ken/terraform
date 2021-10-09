variable "name" {}
variable "policy" {}
variable "identifier" {}
variable "tags" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = format("role-for-%s", var.name)
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = var.tags
}

resource "aws_iam_policy" "default" {
  name   = format("policy-for-%s", var.name)
  policy = var.policy
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_role.default.name
}
