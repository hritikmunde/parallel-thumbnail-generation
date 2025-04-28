# AWS settings
variable "aws_region" {
    description = "AWS region to deploy resources"
    type        = string
    default     = "us-east-2" # Change if needed
}

variable "aws_profile" {
    description = "AWS CLI profile to use for credentials"
    type        = string
    default     = "default"
}

# VPC settings
variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

# EKS settings
variable "cluster_name" {
    description = "Name of the EKS cluster"
    type        = string
    default     = "thumbnail-generator-cluster"
}

# S3 settings
variable "s3_bucket_name" {
    description = "S3 bucket name for storing thumbnails"
    type        = string
}

