# EC2 with VPC

This module creates one VPC, one subnet, an internet gateway and default route, a security group, and one EC2 instance. It does not create an SSH key pair or IAM instance profile; provide existing resources when needed.

The subnet has an internet-gateway route, but the instance receives no public IPv4 address by default. No inbound traffic is allowed unless `ingress_rules` are supplied. Outbound IPv4 traffic is allowed. Set `assign_public_ip = true` only when a public address is intended. A private instance without a public IP has no direct internet egress from this module because no NAT gateway is created.

The calling configuration must configure the AWS provider and supply an AMI ID valid in that provider's region.

```hcl
module "ec2_vpc" {
  source = "./modules/ec2-vpc"

  name   = "example"
  ami_id = "ami-0123456789abcdef0"

  ingress_rules = [
    {
      description = "SSH from the administrator's network"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "203.0.113.10/32"
    }
  ]
}
```