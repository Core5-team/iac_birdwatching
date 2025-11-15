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
  description = "AMI ID for DB instance"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_pair" {
  type        = string
  description = "SSH key pair name"
}

variable "availability_zone" {
  type        = string
  description = "Availability zone"
}

variable "db_subnet_cidr" {
  type        = string
  description = "CIDR block for DB private subnet"
}
variable "nat_gateway_id" {
  type = string
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to access DB"
  default     = ["0.0.0.0/0"]
}

variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags applied to all resources"
}
variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile for DB server (optional)"
  default     = null
}
