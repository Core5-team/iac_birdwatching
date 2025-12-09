variable "env" {
  type        = string
  description = "Environment (dev/stage/prod)"
}

variable "unsplash_key" {
  type        = string
  description = "API key for Unsplash service"
}
variable "birdwatch_url" {
  type        = string
  description = "URL for request to birdwatching"
}
variable "mail_service" {
  type        = string
  description = "URL for request to Mail service"
}
variable "illuminati_backend" {
  type        = string
  description = "URL for request to Illuminati backend service"
}

variable "zip_file_path" {
  type        = string
  description = "Path to the Lambda deployment package zip file"
}
