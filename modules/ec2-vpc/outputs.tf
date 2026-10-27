output "instance_id" {
  description = "ID of the EC2 instance."
  value       = aws_instance.this.id
}

output "instance_private_ip" {
  description = "Private IPv4 address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "instance_public_ip" {
  description = "Public IPv4 address of the EC2 instance, if assigned."
  value       = aws_instance.this.public_ip
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID of the subnet."
  value       = aws_subnet.this.id
}

output "security_group_id" {
  description = "ID of the instance security group."
  value       = aws_security_group.this.id
}

output "route_table_id" {
  description = "ID of the subnet route table."
  value       = aws_route_table.this.id
}