variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "igw_id" {
  description = "Internet Gateway ID"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "AZ to place resources"
  type        = string
}

variable "env" {
  description = "Environment name (dev/stage/prod)"
  type        = string
  default     = "stage"
}

variable "common_tags" {
  type = map(string)
  default = {
    CreatedBy   = "Terraform"
    Project     = "Illuminati"
    Environment = "stage"
  }
}


variable "lb" {
  type = object({
    ami                = string
    instance_type      = string
    key_name           = string
    dns_name           = string
    public_subnet_cidr = string
  })
}

variable "web" {
  type = object({
    ami                     = string
    instance_type           = string
    key_name                = string
    private_web_subnet_cidr = string
    allowed_cidrs           = list(string)
  })
}

variable "db" {
  type = object({
    ami            = string
    instance_type  = string
    key_pair       = string
    db_subnet_cidr = string
    allowed_cidrs  = list(string)
  })
}

