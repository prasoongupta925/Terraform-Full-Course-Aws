# Day 6 - Terraform Project Structure

This project demonstrates **organized Terraform file structure**.

## 📂 File Structure
```
day06/
├── backend.tf          # Remote state configuration
├── providers.tf        # AWS provider setup
├── variables.tf        # Input variables
├── locals.tf          # Computed values
├── main.tf            # Resources ONLY
├── outputs.tf         # Output values
├── terraform.tfvars   # Variable values
├── .gitignore         # Git exclusions
└── README.md          # Documentation
```

## 🚀 Usage
```bash
# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan

# Apply
terraform apply -auto-approve

# Outputs
terraform output

# Cleanup
terraform destroy -auto-approve
```

## 📚 Resources

- S3 Bucket with versioning
- VPC with DNS support
- EC2 Instance (t2.micro)

## 🔐 Security

- `terraform.tfvars` excluded from Git
- State files excluded from Git
- Never commit secrets

---

**Part of:** [30 Days of Terraform AWS](https://github.com/prasoongupta925/Terraform-Full-Course-Aws)
