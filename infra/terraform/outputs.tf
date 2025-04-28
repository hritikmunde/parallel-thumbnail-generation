output "cluster_name" {
    description = "EKS cluster name"
    value       = module.eks.cluster_name
}

output "cluster_endpoint" {
    description = "EKS cluster endpoint"
    value       = module.eks.cluster_endpoint
}

output "node_group_role_arn" {
    description = "Node group IAM role ARN"
    value       = module.iam.node_role_arn
}

output "vpc_id" {
    description = "VPC ID"
    value       = module.vpc.vpc_id
}

output "subnet_ids" {
    description = "Subnet IDs"
    value       = module.vpc.subnet_ids
}

output "s3_bucket_name" {
    description = "S3 Bucket Name"
    value       = module.s3.bucket_name
}
