terraform {
  backend "s3" {
    bucket = "prasoon-gupta-terraform-learning-bucket.tfstate"
    key    = "lessons/day15/terraform.tfstate"
    region = "us-east-1"
  }
}
