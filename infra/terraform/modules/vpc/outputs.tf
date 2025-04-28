output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.this.id
}

output "subnet_ids" {
    description = "List of public subnet IDs"
    value       = aws_subnet.public[*].id
}

output "availability_zones" {
    description = "Availability zones used"
    value       = var.availability_zones
}