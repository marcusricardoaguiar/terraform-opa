variable "project_id" {
  description = "The GCP target project ID"
  type        = string
  default     = "terraform-opa"
}

variable "region" {
  description = "The GCP target region"
  type        = string
  default     = "us-central1"
}
