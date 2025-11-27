# Day 3 - Creating VPC and S3 Bucket with Implicit Dependency

terraform {
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

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "terraform-vpc"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Create S3 Bucket with implicit dependency on VPC
resource "aws_s3_bucket" "vpc_logs_bucket" {
  # Bucket name includes VPC ID - creates implicit dependency
  bucket = "tech-tutorials-vpc-logs-${aws_vpc.main_vpc.id}"

  tags = {
    Name        = "VPC Flow Logs Bucket"
    Environment = "dev"
    VPC_ID      = aws_vpc.main_vpc.id
    ManagedBy   = "Terraform"
  }
}

# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "vpc_logs_versioning" {
  bucket = aws_s3_bucket.vpc_logs_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Output values
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.vpc_logs_bucket.id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.vpc_logs_bucket.arn
}
