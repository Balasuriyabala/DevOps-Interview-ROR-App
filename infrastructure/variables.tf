# AWS REGION
variable "aws_region_mumbai" {
  description = "mumbai"
  type = string
  default = "ap-south-1"
}

#AWS VPC
variable "cidr_block" {
    type = string
    description = "for my_vpc"
    default = "10.0.0.0/16"
}
variable "instance_tenancy" {
  description = "Instance tenancy for the VPC"
  type        = string
  default     = "default" 
} 

# AWS SUBNETS
variable "cidr_block_public1a" {
    type = string
    default = "10.0.1.0/24"
} 

variable "cidr_block_public1b" {
    type = string
    default = "10.0.2.0/24"
} 

variable "cidr_block_private1a" {
    type = string
    default = "10.0.3.0/24"
} 
variable "cidr_block_private1b" {
  type    = string
  default = "10.0.4.0/24"
}

# DATABASE
variable "database_host" {
    type = string
    default = "postgres"
}

variable "database_name" {
    type = string
    default = "rails"
}

variable "database_user" {
    type = string
    default = "postgres"
}
variable "database_password" {
    type = string
    default = "postgres"
}

# S3
variable "s3_bucket_name" {
    type = string
    default = "rubyrails-0370"
}

#ECR
variable "ecr_image_url" {
    type = string
    default = "381491890370.dkr.ecr.ap-south-1.amazonaws.com/ror:latest"
}

variable "nginx_image_url" {
    type = string
    default = "381491890370.dkr.ecr.ap-south-1.amazonaws.com/nginx:latest"
}

# Cloudwatch
variable "aws_region" {
    type = string
    default = "ap-south-1"  
}

variable "logs_group" {
        default = "/ecs/app"
}