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

variable "unsplash_url" {
  type        = string
  description = "URL for Unsplash API"
}

variable "ebird_api_key" {
  type        = string
  description = "API key for eBird service"
}

variable "ebird_url" {
  type        = string
  description = "URL for eBird API"
}

variable "zip_bucket_name" {
  description = "S3 bucket name where Lambda zip files are stored"
  type        = string
}

variable "zip_object_key" {
  description = "S3 object key for the Lambda zip file"
  type        = string
}
