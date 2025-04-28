output "worker_sg_id" {
    description = "Security Group ID for EKS Worker Nodes"
    value       = aws_security_group.worker_sg.id
}
