output "MCP_instance_id" {
  description = "MCP EC2 instance ID"
  value       = aws_instance.mcp.id
}

output "mcp_private_ip" {
  description = "Private IP of MCP instance"
  value       = aws_instance.mcp.private_ip
}

output "mcp_subnet_id" {
  description = "MCP private subnet ID"
  value       = aws_subnet.mcp_subnet.id
}

output "mcp_security_group_id" {
  description = "Security group used by MCP instance"
  value       = aws_security_group.mcp_sg.id
}

output "mcp_volume_id" {
  description = "Attached MCP EBS volume ID"
  value       = aws_ebs_volume.mcp_volume.id
}

