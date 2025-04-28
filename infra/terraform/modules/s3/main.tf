terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
        }
    }
}
# Create S3 Bucket
resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name

    tags = {
    Name = var.bucket_name
    }
}

# Enable Public Read Access to Thumbnails (Optional, depending on use-case)
# resource "aws_s3_bucket_acl" "this" {
#     bucket = aws_s3_bucket.this.id
#     acl    = "private"
# }

# (Optional) Block Public Access settings for extra security
resource "aws_s3_bucket_public_access_block" "this" {
    bucket                  = aws_s3_bucket.this.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}
