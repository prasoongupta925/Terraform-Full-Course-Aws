# Day 6 - Local Variables
# Computed values used within configuration

locals {
  # Construct bucket name from variables
  bucket_name = "${var.channel_name}-bucket-${var.environment}-${var.region}"
  
  # VPC name
  vpc_name = "${var.environment}-VPC"
  
  # EC2 instance name
  instance_name = "${var.environment}-EC2-instance"
  
  # Common tags applied to all resources
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Region      = var.region
    Project     = "30DaysOfTerraform"
  }
}
