# Create an Artifactory repository
resource "google_artifact_registry_repository" "artifactory_repository" {
  project       = var.project_id
  location      = var.region
  repository_id = "cloud-function-artifact-regsitry"
  format        = "DOCKER"
  description   = "cloud-function repository repository "
}


# Grant permissions for Cloud Function to push images
resource "google_artifact_registry_repository_iam_binding" "cloud_function_iam_binding" {
  repository = google_artifact_registry_repository.artifactory_repository.name
  location   = var.region
  role       = "roles/artifactregistry.writer"
  project    = var.project_id

  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}