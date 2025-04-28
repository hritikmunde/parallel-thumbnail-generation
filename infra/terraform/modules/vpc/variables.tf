variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "availability_zones" {
    description = "List of availability zones for subnets"
    type        = list(string)
}

variable "name_prefix" {
    description = "Prefix for naming AWS resources"
    type        = string
    default     = "thumbnail"
}
