# Day 6 - Output Variables
# Values returned after resource creation

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.sample.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.sample.cidr_block
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.sample.id
}

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.sample.public_ip
}
