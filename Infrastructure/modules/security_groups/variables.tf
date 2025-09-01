variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "eks_cluster_sg_id" {
  type = string
}

variable "jenkins_sg_id" {
  type = string
}
