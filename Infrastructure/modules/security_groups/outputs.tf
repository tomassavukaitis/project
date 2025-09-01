output "jenkins_sg_id" {
  description = "Security group ID for Jenkins host"
  value       = aws_security_group.jenkins_sg.id
}
