# VPC Module
module "vpc" {
    source             = "./modules/vpc"
    vpc_cidr_block     = var.vpc_cidr_block
    availability_zones = ["us-east-2a", "us-east-2b"] # Adjust if using different region
    name_prefix        = "thumbnail"
}

# Security Group Module
module "security_group" {
    source    = "./modules/security-group"
    vpc_id    = module.vpc.vpc_id
    name_prefix = "thumbnail"
}

# IAM Module
module "iam" {
    source      = "./modules/iam"
    name_prefix = "thumbnail"
}

# EKS Module
module "eks" {
    source             = "./modules/eks"
    cluster_name       = var.cluster_name
    cluster_role_arn   = module.iam.cluster_role_arn
    node_role_arn      = module.iam.node_role_arn
    subnet_ids         = module.vpc.subnet_ids
    security_group_ids = [module.security_group.worker_sg_id]

    desired_capacity   = 2
    min_capacity       = 1
    max_capacity       = 4
    instance_types     = ["t3.medium"]
}

# S3 Bucket Module
module "s3" {
    source       = "./modules/s3"
    bucket_name  = var.s3_bucket_name
}
