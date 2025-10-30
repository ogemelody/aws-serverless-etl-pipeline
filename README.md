
# Serverless ETL Pipeline Project

## Project Overview
This project demonstrates a **serverless ETL pipeline** using AWS services. Files uploaded to an S3 bucket automatically trigger a Lambda function which logs file metadata and moves files to a processed folder. The infrastructure is provisioned entirely with **Terraform**, and monitoring is done via **CloudWatch logs**.

## Architecture
         +-----------------------+
         |                       |
         |   S3 Bucket           |
         | device-events-        |
         | serveless-project     |
         +-----------+-----------+
                     |
                     | ObjectCreated events
                     v
         +-----------------------+
         |                       |
         |   Lambda Function     |
         |      etl_lambda       |
         |   - Triggered by S3   |
         |   - Prints event info |
         +-----------+-----------+
                     |
                     | Logs of execution
                     v
         +-----------------------+
         |                       |
         | CloudWatch Logs       |
         | /aws/lambda/etl_lambda|
         |   - Shows uploaded    |
         |     file details      |
         +-----------------------+


## AWS Services Used
- **S3:** Storage for uploaded files.  
- **Lambda:** Processes uploaded files and performs basic ETL.  
- **CloudWatch Logs:** Tracks execution and logs metadata.  
- **Terraform:** Infrastructure as code.  
- **EventBridge:** Optional routing of events to Lambda.  

## Features
- Automatic processing of uploaded files.  
- Logs metadata: file name, size, type.  
- Moves files to `processed/` folder.  
- Fully automated provisioning with Terraform.  
- CI/CD workflow with GitHub Actions for Terraform formatting and plan.  

## Getting Started

### Prerequisites
- AWS account with S3 and Lambda permissions  
- Terraform installed  
- AWS CLI configured  

### Deploy
1. Update Lambda code and zip it:

```bash
cd lambda
zip -r lambda_function.zip lambda_function.py

```

2. Apply Terraform
```bash
cd terraform
terraform init
terraform apply
```

3. Upload a test file
```bash
aws s3 cp test_image.jpg s3://device-events-serveless-project/
```
4. Verify Lambda logs:
```bash
aws logs tail /aws/lambda/etl_lambda --follow

```

## CI/CD
GitHub Actions workflow checks Terraform formatting (terraform fmt --check)
## Learning Outcomes
- Understanding serverless pipelines with S3 and Lambda
- Automating AWS infrastructure with Terraform
- Event-driven architecture concepts
- CI/CD for infrastructure as code