variable "name" {
  description = "Name used for the EC2 instance and related resources."
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "IPv4 CIDR block for the subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the subnet. Defaults to the provider-selected zone."
  type        = string
  default     = null
  nullable    = true
}

variable "assign_public_ip" {
  description = "Whether to assign a public IPv4 address to the instance."
  type        = bool
  default     = false
}

variable "ingress_rules" {
  description = "Optional IPv4 ingress rules. No inbound traffic is allowed by default."
  type = list(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    cidr_ipv4   = string
  }))
  default = []
}

variable "key_name" {
  description = "Optional existing EC2 key pair name."
  type        = string
  default     = null
  nullable    = true
}

variable "iam_instance_profile" {
  description = "Optional existing IAM instance profile name."
  type        = string
  default     = null
  nullable    = true
}

variable "root_volume_size" {
  description = "Size in GiB of the encrypted gp3 root volume."
  type        = number
  default     = 8
}

variable "tags" {
  description = "Tags applied to created resources."
  type        = map(string)
  default     = {}
}