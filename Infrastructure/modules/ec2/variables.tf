variable "ami_id" {
  description = "AMI ID to launch Jenkins host"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Jenkins instance"
  type        = string
}

variable "jenkins_sg_id" {
  description = "Security group ID for Jenkins host"
  type        = string
}
