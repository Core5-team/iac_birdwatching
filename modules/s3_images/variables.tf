variable "env" {
  type = string
  description = "Environment name (dev, stage, prod)"
}

variable "project" {
  type    = string
  default = "illuminati"
  description = "Project name used as a prefix for resource naming"
}

variable "common_tags" {
  type = map(string)
  description = "Common tags applied to all resources in this module"
}

