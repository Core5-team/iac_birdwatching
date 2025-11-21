output "lb_public_ip" {
  value       = module.lb.public_ip
  description = "Public IP of LB instance"
}

output "lb_subnet_id" {
  value = module.lb.subnet_id
  description = "Subnet ID where the load balancer is deployed"
}

output "lb_security_group_id" {
  value = module.lb.security_group_id
  description = "Security group ID associated with the load balancer"
}

output "web_instance_ids" {
  value       = module.web.web_instance_ids
  description = "List of EC2 IDs of web servers"
}

output "web_subnet_id" {
  value = module.web.subnet_id
  description = "Subnet ID for web server instances"
}

output "web_security_group_id" {
  value = module.web.security_group_id
  description = "Security group ID for web server instances"
}

output "db_instance_id" {
  value = module.db.db_instance_id
  description = "Database instance ID"
}

output "db_subnet_id" {
  value = module.db.db_subnet_id
  description = "Subnet ID where the database instance is deployed"
}

output "db_security_group_id" {
  value = module.db.db_security_group_id
  description = "Security group ID for the database instance"
}

output "db_private_ip" {
  value = module.db.db_private_ip
  description = "Private IP address of the database instance"
}

output "images_bucket_name" {
  description = "S3 bucket for images"
  value       = module.images.bucket_name
}

output "images_bucket_arn" {
  description = "ARN of Images S3 bucket"
  value       = module.images.bucket_arn
}

