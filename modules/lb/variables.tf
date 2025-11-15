variable "env" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "ami" {
  type        = string
  description = "AMI ID for load balancer"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "dns_name" {
  type        = string
  description = "DNS zone name"
}


variable "igw_id" {
  type    = string
  default = null
}
variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for public LB subnet"
}

variable "allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to access LB"
}

variable "availability_zone" {
  type = string
}


variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for LB server (optional)"
  default     = null
}
