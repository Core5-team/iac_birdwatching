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
  description = "AMI ID for web servers"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name"
}

variable "private_web_subnet_cidr" {
  type        = string
  description = "CIDR for private web subnet"
}
variable "nat_gateway_id" {
  type = string
}

variable "allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "availability_zone" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

