variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "EKS control-plane security group ID"
  type        = string
}

variable "allowed_jenkins_cidr" {
  description = "Source CIDR for Jenkins access"
  type        = string
}

variable "allowed_home_cidr" {
  description = "Your home/public CIDR to access EKS API/nodes"
  type        = string
}

variable "jenkins_sg_id" {
  description = "Security group ID of the Jenkins EC2 instance"
  type        = string
}
