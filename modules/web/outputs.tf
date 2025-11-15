output "web_instance_ids" {
  value       = aws_instance.web[*].id
  description = "Web server EC2 instance IDs"
}

output "subnet_id" {
  value       = aws_subnet.private_web_subnet.id
  description = "Private web subnet ID"
}

output "security_group_id" {
  value       = aws_security_group.web_sg.id
  description = "Web security group ID"
}

output "iam_instance_profile_name" {
  value       = aws_iam_instance_profile.photosaver_profile.name
  description = "IAM instance profile name for web servers"
}
