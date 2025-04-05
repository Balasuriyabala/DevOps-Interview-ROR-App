## Project Overview:
## GoaL
Deploy a Ruby on Rails web application to AWS using ECS/EKS with a secure, scalable infrastructure via Infrastructure as Code (IaC)

## AWS Services:
ECR – Docker image repository
ECS Fargate – Container orchestration
RDS (PostgreSQL) – Database
S3 – File storage
ALB (ELB) – Load balancing
IAM – Secure role-based access
VPC/Subnets – Private networking
IaC Tool: Terraform

## Deployment Steps:
1. Clone github repo to aws ubuntu server build image
2. Push the Image to AWS ECR
3. Install the terraform in server or local machine (install aws cli)
4. Under the infrastructure folder write the IAC code for services to deploy db credentail are stored in variable file
5. terrafrom init, terraform paln, terrafrom validate, terrafrom apply (to delete entire infra terrafrom destroy)

## Best Practices
1. Terrafrom code for automating creation of cloud services
2. Private subnet for DB (Postgres)
3. Public subnet for only ALB to distribute the application traffic
4. IAM roles in ECS are used for secure purposes.

## DIAGRAM


<img width="664" alt="Image" src="https://github.com/user-attachments/assets/f818b9e8-5163-408e-b48a-62ee4e11a035" />
