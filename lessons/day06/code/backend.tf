# Day 6 - Backend Configuration
# Remote state stored in S3

terraform {
  backend "s3" {
    bucket       = "tech-tutorials-prasoon-terraform-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}