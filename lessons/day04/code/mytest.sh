#!/bin/bash

# Day 4 - Terraform Remote Backend Testing Script
# This script tests the complete remote backend workflow

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
STATE_BUCKET="tech-tutorials-prasoon-terraform-state"
REGION="us-east-1"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Day 4: Testing Remote Backend Setup${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Step 1: Check if AWS CLI is configured
echo -e "${YELLOW}Step 1: Checking AWS CLI configuration...${NC}"
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}Error: AWS CLI is not configured. Run 'aws configure' first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ AWS CLI is configured${NC}\n"

# Step 2: Check if state bucket exists
echo -e "${YELLOW}Step 2: Checking if state bucket exists...${NC}"
if ! aws s3 ls "s3://${STATE_BUCKET}" &> /dev/null; then
    echo -e "${RED}Error: State bucket '${STATE_BUCKET}' does not exist.${NC}"
    echo -e "${YELLOW}Creating state bucket...${NC}"
    
    # Create bucket
    aws s3 mb "s3://${STATE_BUCKET}" --region "${REGION}"
    
    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket "${STATE_BUCKET}" \
        --versioning-configuration Status=Enabled
    
    # Enable encryption
    aws s3api put-bucket-encryption \
        --bucket "${STATE_BUCKET}" \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "AES256"
                }
            }]
        }'
    
    echo -e "${GREEN}✓ State bucket created and configured${NC}\n"
else
    echo -e "${GREEN}✓ State bucket exists${NC}\n"
fi

# Step 3: Initialize Terraform
echo -e "${YELLOW}Step 3: Initializing Terraform with remote backend...${NC}"
terraform init
echo -e "${GREEN}✓ Terraform initialized${NC}\n"

# Step 4: Validate configuration
echo -e "${YELLOW}Step 4: Validating Terraform configuration...${NC}"
terraform validate
echo -e "${GREEN}✓ Configuration is valid${NC}\n"

# Step 5: Format check
echo -e "${YELLOW}Step 5: Checking Terraform formatting...${NC}"
terraform fmt -check
echo -e "${GREEN}✓ Formatting is correct${NC}\n"

# Step 6: Plan infrastructure
echo -e "${YELLOW}Step 6: Planning infrastructure changes...${NC}"
terraform plan -out=tfplan
echo -e "${GREEN}✓ Plan created${NC}\n"

# Step 7: Apply infrastructure
echo -e "${YELLOW}Step 7: Applying infrastructure changes...${NC}"
read -p "Do you want to apply these changes? (yes/no): " confirm
if [ "$confirm" == "yes" ]; then
    terraform apply tfplan
    echo -e "${GREEN}✓ Infrastructure created${NC}\n"
else
    echo -e "${YELLOW}Skipping apply step${NC}\n"
    rm tfplan
    exit 0
fi

# Step 8: Verify state in S3
echo -e "${YELLOW}Step 8: Verifying state file in S3...${NC}"
if aws s3 ls "s3://${STATE_BUCKET}/dev/terraform.tfstate" &> /dev/null; then
    echo -e "${GREEN}✓ State file exists in S3${NC}"
    
    # Get state file size
    SIZE=$(aws s3 ls "s3://${STATE_BUCKET}/dev/terraform.tfstate" | awk '{print $3}')
    echo -e "${BLUE}State file size: ${SIZE} bytes${NC}\n"
else
    echo -e "${RED}Error: State file not found in S3${NC}\n"
    exit 1
fi

# Step 9: List resources in state
echo -e "${YELLOW}Step 9: Listing resources in state...${NC}"
terraform state list
echo -e "${GREEN}✓ State listing complete${NC}\n"

# Step 10: Show demo bucket details
echo -e "${YELLOW}Step 10: Showing demo bucket details...${NC}"
terraform state show aws_s3_bucket.demo_bucket
echo -e "${GREEN}✓ Resource details displayed${NC}\n"

# Step 11: Verify outputs
echo -e "${YELLOW}Step 11: Verifying outputs...${NC}"
terraform output
echo -e "${GREEN}✓ Outputs displayed${NC}\n"

# Step 12: Test state locking (optional)
echo -e "${YELLOW}Step 12: Testing state locking...${NC}"
echo -e "${BLUE}State locking is automatic with use_lockfile=true${NC}"
echo -e "${BLUE}Try running 'terraform plan' in another terminal to see locking in action${NC}\n"

# Step 13: Cleanup prompt
echo -e "${YELLOW}Step 13: Cleanup${NC}"
read -p "Do you want to destroy the infrastructure? (yes/no): " cleanup
if [ "$cleanup" == "yes" ]; then
    terraform destroy -auto-approve
    echo -e "${GREEN}✓ Infrastructure destroyed${NC}\n"
else
    echo -e "${YELLOW}Infrastructure left intact${NC}\n"
fi

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}All tests completed successfully!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${BLUE}Next steps:${NC}"
echo -e "1. Check AWS Console → S3 → ${STATE_BUCKET}/dev/"
echo -e "2. Try 'terraform state' commands"
echo -e "3. Test with multiple team members"
echo -e "4. Enable S3 bucket versioning to track state history\n"

# Cleanup plan file
rm -f tfplan

exit 0
