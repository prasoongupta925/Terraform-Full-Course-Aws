# i am crating this file exactly as shown in video of day 5 youtube that i practice it already and understand it

terraform {

#https://developer.hashicorp.com/terraform/language/backend/s3
#Example Configuration
  backend "s3" {
    bucket = "prasoon-gupta-terraform-learning-bucket.tfstate"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    #lock_table = "prasoon-gupta-terraform-learning-locks"
    use_lockfile = true
  }
  
  required_providers {
    aws = { 
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Define variables
variable "environment" {
    default = "Dev"
    type    = string
}

variable "channel_name" {
    #default = "prasoon-gupta-terraform-learning"
    default = "pgtl"
    type    = string
}

variable "region" {
    default = "us-east-1"
  
}
locals {
    bucket_name = "${var.channel_name}-bucket-${var.environment}-${var.region}"
    vpc_name    = "${var.environment}-VPC"
}



# create s3 bucket  
resource "aws_s3_bucket" "example" {
  #bucket = "prasoon-gupta-terraform-learning-bucket"
    bucket = local.bucket_name
 
 tags = {
    #Name        = "My bucket"
    #Environment = "Dev"
    Name        = local.bucket_name
    #Name        = "${var.environment}-Bucket"
    #Name        = "Dev-Bucket"
    Environment = var.environment
  }
#  tags = {
#     Name        = "My bucket 2.0"
#     Environment = "Dev"
#   }
}

# Enable versioning on the S3 bucket
# Versioning keeps multiple variants of an object in the same bucket
# This allows you to recover from accidental deletions or overwrites of the state file
resource "aws_s3_bucket_versioning" "example" {
  bucket = aws_s3_bucket.example.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for the S3 bucket
# This encrypts all objects stored in the bucket at rest using AES256 encryption
# Protects sensitive data in the Terraform state file (like resource IDs, IP addresses, etc.)
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"  # Uses Amazon S3-managed encryption keys
    }
  }
}

#create vpc
resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  #region     = "us-east-1"  
  region = var.region
    tags = {
       #Environment = "Dev"
        Environment = var.environment
       #Name        = "Dev-VPC"
       #Name        = "${var.environment}-VPC"
       Name        = local.vpc_name
        }
}

#create Ec2 instance
resource "aws_instance" "example" {
    ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
    instance_type = "t2.micro"
    #region = "us-east-1"
    region = var.region
    #subnet_id = aws_subnet.sample.id
    tags = {
      #Environment = "Dev"
        Environment = var.environment
      #Name        = "Dev-Instance"
      Name        = "${var.environment}-Instance"
    }
}



#output variables

output "vpc_id" {
  value = aws_vpc.sample.id
}

output "ec2_id" {
  value = aws_instance.example.id
}
