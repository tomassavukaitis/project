output "cluster_name" {
  value = aws_eks_cluster.EKS.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.EKS.endpoint
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.EKS.certificate_authority[0].data
}
