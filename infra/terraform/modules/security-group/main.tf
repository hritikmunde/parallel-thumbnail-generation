terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# Security Group for Worker Nodes (EKS + API + Celery workers)
resource "aws_security_group" "worker_sg" {
    name        = "${var.name_prefix}-worker-sg"
    description = "Security group for EKS worker nodes and pods"
    vpc_id      = var.vpc_id

    ingress {
        description = "Allow all traffic from within the same security group (pods talking to each other)"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self        = true
    }

    ingress {
        description = "Allow API access from internet"
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow Redis port access from within the security group"
        from_port   = 6379
        to_port     = 6379
        protocol    = "tcp"
        self        = true
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name_prefix}-worker-sg"
    }
}   