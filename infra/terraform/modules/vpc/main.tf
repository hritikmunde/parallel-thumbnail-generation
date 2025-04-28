terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# Create VPC
resource "aws_vpc" "this" {
    cidr_block           = var.vpc_cidr_block
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
    Name = "${var.name_prefix}-vpc"
    }
}

# Create Public Subnets
resource "aws_subnet" "public" {
    count                   = 2
    vpc_id                  = aws_vpc.this.id
    cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
    availability_zone       = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
    tags = {
    Name = "${var.name_prefix}-public-subnet-${count.index}"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
    tags = {
    Name = "${var.name_prefix}-igw"
    }
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id
    tags = {
    Name = "${var.name_prefix}-public-rt"
    }
}

# Route to Internet
resource "aws_route" "internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.this.id
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "public" {
    count          = length(aws_subnet.public)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}
