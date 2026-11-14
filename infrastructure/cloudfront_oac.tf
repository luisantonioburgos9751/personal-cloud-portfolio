
resource "aws_cloudfront_origin_access_control" "portfolio" {
  name                              = "oac-personal-cloud-portfolio-web-141353495450-us-eas-mwcjoapy8bp"
  description                       = "Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
