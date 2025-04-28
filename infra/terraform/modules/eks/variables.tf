variable "cluster_name" {
    description = "Name of the EKS Cluster"
    type        = string
}

variable "cluster_role_arn" {
    description = "IAM role ARN for EKS cluster"
    type        = string
}

variable "node_role_arn" {
    description = "IAM role ARN for Node Group"
    type        = string
}

variable "subnet_ids" {
    description = "Subnets where EKS worker nodes will run"
    type        = list(string)
}

variable "security_group_ids" {
    description = "Security groups for EKS cluster"
    type        = list(string)
}

variable "desired_capacity" {
    description = "Desired number of nodes"
    type        = number
    default     = 2
}

variable "min_capacity" {
    description = "Minimum number of nodes"
    type        = number
    default     = 1
}

variable "max_capacity" {
    description = "Maximum number of nodes"
    type        = number
    default     = 4
}

variable "instance_types" {
    description = "List of EC2 instance types for nodes"
    type        = list(string)
    default     = ["t3.medium"]
}
