## Project Overview:
Testing
Deploy a Ruby on Rails web application

Deployment On Cloud Server
1.Update ENV file
2. Run the docker-compose up -d Console Output

<img width="836" alt="Image" src="https://github.com/user-attachments/assets/fe029419-972a-4078-9df4-72adcd56080e" />

<img width="329" alt="Image" src="https://github.com/user-attachments/assets/16ff3eee-a2fb-4c7b-bb78-d2e34e3dc9d1" />

<img width="932" alt="Image" src="https://github.com/user-attachments/assets/44bb023e-6fc0-417f-b8e6-5bfd39f00343" />

## Goal
Deploy a Ruby on Rails web application to AWS using ECS/EKS with a secure, scalable infrastructure via Infrastructure as Code (IaC)

## AWS Services
ECR – Docker image repository ECS Fargate – Container orchestration RDS (PostgreSQL) – Database S3 – File storage ALB (ELB) – Load balancing IAM – Secure role-based access VPC/Subnets – Private networking IaC Tool: Terraform

 ## Deployment Steps
1.Clone the repos to cloud server
2.Create a access key, secerete key, region.
3.Create a AWS ECR which is used to store the docker image in it, command are given how to push image 
   3.1 aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 381491890370.dkr.ecr.ap-south-1.amazonaws.com 
    3.2 docker build -t 
    3.3 docker tag 
    3.4 docker push
4.Once are image pushed mention in the varible.tf file that images used for container
5.Install the terraform in server or local machine (install aws cli)
6.Under the infrastructure folder write the IAC code for services to deploy db credentail are stored in variable file
7.terrafrom init, terraform paln, terrafrom validate, terrafrom apply (to delete entire infra terrafrom destroy)

## Best Practices
1.Terrafrom code for automating creation of cloud services
2.Private subnet for DB (Postgres)
3.Public subnet for only ALB to distribute the application traffic
4.IAM roles in ECS are used for secure purposes.

Internet → ALB (public subnet) → ECS Rails App (private subnet) → RDS DB (private subnet) 

## DIAGRAM

<img width="734" alt="Image" src="https://github.com/user-attachments/assets/35384676-b65e-4c37-8776-870e86207c06" />

## NOTE:
Terraform module can be written by using each service as module and call from main.tf file for secerte storing we can use  secretsmanager

