output "bucket_name" {
  value = aws_s3_bucket.images.bucket
  description = "Name of the S3 bucket for storing images"
}

output "bucket_arn" {
  value = aws_s3_bucket.images.arn
  description = "ARN of the S3 bucket for storing images"
}
