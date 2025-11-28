# Day 4 - Terraform State File Management with Remote Backend (S3)
# 
# This configuration demonstrates:
# 1. Remote backend setup with S3
# 2. State file encryption
# 3. State locking with use_lockfile
# 4. Example resources with versioning and encryption

terraform {
  # Configure Remote Backend (S3)
  # NOTE: The S3 bucket must be created BEFORE running terraform init
  backend "s3" {
    bucket         = "tech-tutorials-prasoon-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true  # New S3 native locking (no DynamoDB needed)
  }

  # Provider Configuration
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

# Example Resource - S3 Bucket for Demo
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "tech-tutorials-prasoon-demo-2024"

  tags = {
    Name        = "Demo Bucket"
    Environment = "dev"
    ManagedBy   = "Terraform"
    Purpose     = "Learning Remote Backend"
  }
}

# Enable Versioning on Demo Bucket
resource "aws_s3_bucket_versioning" "demo_versioning" {
  bucket = aws_s3_bucket.demo_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Encryption on Demo Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "demo_encryption" {
  bucket = aws_s3_bucket.demo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access for Demo Bucket
resource "aws_s3_bucket_public_access_block" "demo_public_access_block" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Outputs
output "demo_bucket_name" {
  description = "Name of the demo bucket"
  value       = aws_s3_bucket.demo_bucket.id
}

output "demo_bucket_arn" {
  description = "ARN of the demo bucket"
  value       = aws_s3_bucket.demo_bucket.arn
}

output "demo_bucket_region" {
  description = "Region of the demo bucket"
  value       = aws_s3_bucket.demo_bucket.region
}
