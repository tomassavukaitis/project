output "jenkins_sg_id" {
  description = "Security group ID for Jenkins host"
  value       = aws_security_group.jenkins_sg.id
}

output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}
