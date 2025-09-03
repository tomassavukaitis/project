variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS cluster"
}

variable "node_role_arn" {
  type        = string
  description = "IAM role ARN for the EKS node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}

variable "node_security_group_id" {
  description = "Security group ID to attach to EKS nodes"
  type        = string
}

variable "instance_type" {
  description = "Worker node instance type"
  type        = string
}