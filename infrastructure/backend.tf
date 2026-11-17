
terraform {
  backend "s3" {
    bucket = "personal-cloud-portfolio-tfstate-141353495450-us-east-2-an"
    key = "personal-cloud-portfolio/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true
  }
}
