# cicd-automation

## Terraform workflow

The GitHub Actions workflow runs on pushes, pull requests, and manual dispatch. It checks Terraform formatting across the repository, then initializes and validates the `modules/ec2-vpc` module without configuring a backend or accessing AWS. It does not create or modify infrastructure; deployment requires a separate root configuration and AWS credentials.