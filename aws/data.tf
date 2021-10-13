data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"] # リージョン一覧を取得する
    resources = ["*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "external" "ifconfig" {
  program = ["curl", "httpbin.org/ip"]
}
