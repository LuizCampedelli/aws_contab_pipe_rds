# AWS Contab Pipe RDS

This repository contains the infrastructure code and scripts for deploying an AWS Lambda function to interact with an Amazon RDS database, primarily for financial data processing.

## Overview

- **Purpose**: Automate the processing of financial data using AWS services.
- **Tools**:
  - Terraform for infrastructure as code (IaC)
  - Python for Lambda functions and data manipulation
  - AWS Lambda for serverless computing
  - AWS RDS for relational database services
  - GitHub Actions for CI/CD pipeline

## Repository Structure

- **`.github/workflows/`**: Contains GitHub Actions workflow files for automating deployments.
- `deploy.yml`: Workflow for deploying the Lambda function and setting up the RDS instance.
- **`lambda_dependencies/`**: Stores dependencies required by the Lambda function.
- **`modules/`**: Terraform modules for reusable components.
- **`python/`**: Python scripts and libraries.
- **`lambda_function.py`**: The main Lambda function script for data processing.
- **`main.tf`**: Terraform configuration file for defining AWS resources.
- **`outputs.tf`**: Terraform output values.
- **`variables.tf`**: Terraform variables file.
- **`upload_file.py`**: Script for uploading files, possibly to S3 or another service.
- **`terraform.tfvars`**: Variable values for Terraform.
- **`.gitignore`**: Specifies intentionally untracked files to ignore.
- **`.terraform.lock.hcl`**: Terraform lock file for managing provider versions.
- **`lambda.zip`**: Zipped Lambda function code.
- **`pandas_layer.zip`**: Custom Lambda layer for Pandas library.
- **`lambda_dependencies.zip`**: Custom Lambda layer dependencies for Pandas library layer.
- **`terraform.tfstate`**, **`terraform.tfstate.backup`**: Terraform state files.

## How to Use

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/LuizCampedelli/aws_contab_pipe_rds.git
   ```

### Setup AWS Credentials:
Ensure your AWS credentials are configured either through AWS CLI or environment variables.

### Install Terraform:
If not installed, follow instructions for your OS from the Terraform website.

### Deploy with Terraform:

Navigate to the project directory:
   ```bash
   cd aws_contab_pipe_rds
   ```
Initialize Terraform:

   ```bash
   terraform init
   ```
Plan and Apply:

```bash
terraform plan
terraform apply
```

### Run Lambda Function:
Ensure the Lambda function has the necessary permissions to interact with RDS and other services.
You can manually trigger the Lambda function from AWS Console.

## Additional Notes
Dependencies: The Lambda function relies on external libraries like Pandas, which are included as a custom layer.
Security: Ensure proper IAM roles and policies are set up to grant the necessary permissions for Lambda to access RDS and other AWS services.

## Contributing
Contributions are welcome! Please fork the repository, make your changes, and submit a pull request. Ensure you follow the project's coding standards and commit messages.

## Contact
For any questions or issues, please open an issue or contact LuizCampedelli.
