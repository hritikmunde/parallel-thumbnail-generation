output "cluster_name" {
    description = "EKS Cluster name"
    value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
    description = "EKS Cluster API endpoint"
    value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
    description = "EKS Cluster CA data"
    value       = aws_eks_cluster.this.certificate_authority[0].data
}
