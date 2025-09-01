resource "aws_eks_cluster" "EKS" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.EKS.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t2.small"]
}


resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.EKS.name
  addon_name   = "kube-proxy"
}
