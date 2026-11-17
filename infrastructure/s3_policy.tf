resource "aws_s3_bucket_policy" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id
  policy = data.aws_iam_policy_document.cloudfront_read.json
}

data "aws_iam_policy_document" "cloudfront_read" {

  version   = "2008-10-17"
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid    = "AllowCloudFrontServicePrincipal"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.portfolio.arn}/*"
    ]
    condition {
      test     = "ArnLike"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::141353495450:distribution/E2MNF1NIR58MVI"]
    }
  }
}