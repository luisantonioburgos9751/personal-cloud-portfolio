resource "aws_s3_bucket" "portfolio" {
  bucket = "personal-cloud-portfolio-web-141353495450-us-east-2-an"

  tags = {
    Project     = "PersonalCloudPortfolio"
    Environment = "Development"
  }
}