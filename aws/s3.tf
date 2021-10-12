resource "aws_s3_bucket" "alb_log" {
  bucket = format("%s-alb-log-terraform-test", local.user)
  lifecycle_rule {
    enabled = true
    expiration {
      days = "180"
    }
  }
  tags = local.tags
}

resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
}
