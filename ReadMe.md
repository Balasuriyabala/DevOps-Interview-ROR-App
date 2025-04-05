## Project Overview:
## Testing
Deploy a Ruby on Rails web application
## Deployment On Cloud Server
1. Update ENV file 
2. Run the docker-compose up -d 
Console Output:

<img width="836" alt="Image" src="https://github.com/user-attachments/assets/94a5075e-7dfb-4077-8a34-57d33717f460" />

<img width="329" alt="Image" src="https://github.com/user-attachments/assets/ba7ad82e-27bb-4a22-8128-87233b23e84a" /> 


<img width="932" alt="Image" src="https://github.com/user-attachments/assets/fbb46c29-1b34-461c-8d93-80b7487de6ec" />

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

Internet → ALB (public subnet) → ECS Rails App (private subnet) → RDS DB (private subnet)

## DIAGRAM


<img width="664" alt="Image" src="https://github.com/user-attachments/assets/f818b9e8-5163-408e-b48a-62ee4e11a035" />
