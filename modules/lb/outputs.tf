output "lb_instance_id" {
  value       = aws_instance.lb.id
  description = "Load balancer EC2 instance ID"
}

output "public_ip" {
  value       = aws_eip.lb_eip.public_ip
  description = "Public IP of the load balancer"
}

output "subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "Public subnet ID"
}

output "security_group_id" {
  value       = aws_security_group.lb_sg.id
  description = "Security group ID"
}

output "dns_zone_id" {
  value       = aws_route53_zone.main.zone_id
  description = "Route53 hosted zone ID"
}

output "dns_record_name" {
  value       = aws_route53_record.dns_record.fqdn
  description = "Fully qualified DNS name"
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
