terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# EKS Cluster Role
resource "aws_iam_role" "eks_cluster_role" {
    name = "${var.name_prefix}-eks-cluster-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
        Service = "eks.amazonaws.com"
        }
    }]
    })

    tags = {
    Name = "${var.name_prefix}-eks-cluster-role"
    }
}

# Attach policies to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
    role       = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
    role       = aws_iam_role.eks_cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# EKS Worker Node Group Role
resource "aws_iam_role" "eks_node_role" {
    name = "${var.name_prefix}-eks-node-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow",
        Principal = {
        Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
    }]
    })

    tags = {
    Name = "${var.name_prefix}-eks-node-role"
    }
}

# Attach policies to Node Role
resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
    role       = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
    role       = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
    role       = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonS3FullAccess" {
    role       = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
