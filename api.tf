# resource "google_project_service" "services" {
#   for_each = toset(local.services)
#   project  = var.project_id
#   service  = each.key
#   provisioner "local-exec" {
#     command = "sleep 45"
#   }
#   provisioner "local-exec" {
#     when    = destroy
#     command = "sleep 45"
#   }
#   disable_dependent_services = false
# }


# resource "google_project_service" "cloud_functions_api" {
#   project = var.project_id
#   service = "cloudfunctions.googleapis.com"
# }
# resource "google_project_service" "cloud_build_api" {
#   project = var.project_id
#   service = "cloudbuild.googleapis.com"
# }

# resource "google_project_service" "eventarc_api" {
#   project = var.project_id
#   service = "eventarc.googleapis.com"
# }


# resource "google_project_service" "run_api" {
#   project = var.project_id
#   service = "run.googleapis.com"
# }
# resource "google_project_service" "artifactregistry_api" {
#   project = var.project_id
#   service = "artifactregistry.googleapis.com"
# }
# # resource "google_project_service" "cloudresourcemanager_api" {
# #   project = var.project_id
# #   service = "cloudresourcemanager.googleapis.com"
# # }


