resource "google_project_service" "cloud_functions_api" {
  project = var.project_id
  service = "cloudfunctions.googleapis.com"
}
resource "google_project_service" "cloud_build_api" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

## For cloud function Gen-2

resource "google_project_service" "eventarc_api" {
  project = var.project_id
  service = "eventarc.googleapis.com"
}


resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
}
resource "google_project_service" "artifactregistry_api" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}