variable "jenkins_sg_id" {
  description = "Security group ID for Jenkins host"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the Jenkins host"
  type        = string
}
