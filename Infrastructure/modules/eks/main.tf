resource "aws_eks_cluster" "EKS" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
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
    desired_size = 0
    max_size     = 1
    min_size     = 0
  }

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  depends_on = [aws_eks_cluster.EKS]
}

resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-node-template-"
  instance_type = var.instance_type
  image_id      = data.aws_ami.eks_worker.id

  user_data = base64encode(<<EOF
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${var.cluster_name} --kubelet-extra-args '--node-labels=role=worker'
EOF
  )

  network_interfaces {
    security_groups = [var.node_security_group_id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "eks_worker" {
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
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
