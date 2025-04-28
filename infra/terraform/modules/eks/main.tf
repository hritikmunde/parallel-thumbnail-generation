terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# Create EKS Cluster
resource "aws_eks_cluster" "this" {
    name     = var.cluster_name
    role_arn = var.cluster_role_arn

    vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
    }

    kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"  # Default for EKS
    }

    tags = {
    Name = var.cluster_name
    }

    depends_on = [var.cluster_role_arn]
}

# Create Node Group (Worker Nodes)
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = var.instance_types

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  depends_on = [aws_eks_cluster.this]
}   