variable "project_id" {
  default = "gcp-project-390708"
}

variable "region" {
  default = "europe-west2"
}

variable "service_account_email" {
  type    = string
  default = "project-service-account@gcp-project-390708.iam.gserviceaccount.com"
}