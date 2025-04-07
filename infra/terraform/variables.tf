variable "region" {
    default = "us-east-2"
}

variable "key_pair_name" {
    description = "Name of the AWS key pair to SSH into EC2 instances"
    type        = string
}

variable "instance_type_master" {
    default = "t2.micro"
}

variable "instance_type_worker" {
    default = "t2.micro"
}

variable "ami" {
    description = "Amazon Linux 2 AMI ID for your region"
    type        = string
}
