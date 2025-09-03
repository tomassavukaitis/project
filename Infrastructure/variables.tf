variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "Tomas-EKS-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "jenkins_ami_id" {
  description = "AMI ID for Jenkins EC2 instance"
  type        = string
  default     = "ami-0bc691261a82b32bc"
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins EC2"
  type        = string
  default     = "t2.small"
}

variable "jenkins_key_name" {
  description = "SSH key name for Jenkins EC2"
  type        = string
  default     = "Tomas-Key"
}

variable "allowed_jenkins_cidr" {
  description = "CIDR allowed to SSH/Jenkins UI"
  type        = string
  default     = "84.15.178.126/32"
}

variable "allowed_home_cidr" {
  description = "CIDR allowed to EKS API & nodes"
  type        = string
  default     = "84.15.178.126/32"
}

variable "eks_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}
