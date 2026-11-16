resource "aws_cloudfront_distribution" "portfolio" {
  enabled             = "true"
  default_root_object = "index.html"

  comment         = "CloudFront distribution for my personal cloud engineering portfolio."
  price_class     = "PriceClass_All"
  is_ipv6_enabled = true
  http_version    = "http2"

  tags = {
    Environment = "Development"
    Name        = "PersonalCloudPortfolio-Web"
    Project     = "PersonalCloudPortfolio"
  }

  origin {
    domain_name              = aws_s3_bucket.portfolio.bucket_regional_domain_name
    origin_id                = "personal-cloud-portfolio-web-141353495450-us-east-2-an.s3.us-east-2.amazonaws.com-mwcja2waufa"
    origin_access_control_id = aws_cloudfront_origin_access_control.portfolio.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "personal-cloud-portfolio-web-141353495450-us-east-2-an.s3.us-east-2.amazonaws.com-mwcja2waufa"
    viewer_protocol_policy = "redirect-to-https"
    compress               = "true"

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}