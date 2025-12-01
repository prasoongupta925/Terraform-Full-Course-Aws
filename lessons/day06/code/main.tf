# Day 6 - Main Resource Definitions
# This file now contains ONLY resources (clean and organized!)

# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = local.bucket_name
  
  tags = merge(
    local.common_tags,
    {
      Name = local.bucket_name
    }
  )
}

# VPC
resource "aws_vpc" "sample" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = merge(
    local.common_tags,
    {
      Name = local.vpc_name
    }
  )
}

# EC2 Instance
resource "aws_instance" "sample" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 in us-east-1
  instance_type = var.instance_type
  
  tags = merge(
    local.common_tags,
    {
      Name = local.instance_name
    }
  )
}
