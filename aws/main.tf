module "describe_regions_for_ec2" {
  source     = "./modules/iam_role"
  name       = "describe-regions-for-ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
  tags       = local.tags
}

module "example_sg" {
  source      = "./modules/security_group"
  name        = "module-sg"
  vpc_id      = aws_vpc.example.id
  ports       = [80, 8080, 443]
  cidr_blocks = ["${data.external.ifconfig.result.origin}/32"]
}
