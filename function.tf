# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.function_bucket, # declared in `storage.tf`
    data.archive_file.source
  ]
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "function" {
  name    = "function-trigger-on-gcs"
  runtime = "python37" # of course changeable
  project = var.project_id
  region  = var.region

  # Get the source code of the cloud function as a Zip compression
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.zip.name

  # Must match the function name in the cloud function `main.py` source code
  entry_point = "hello_gcs"

  # 
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "${var.project_id}-input"
  }

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.function_bucket, # declared in `storage.tf`
    google_storage_bucket_object.zip,
    google_project_service.cloud_build_api,
    google_project_service.cloud_functions_api
  ]
}


### cloud function gen-2 

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_project_iam_member" "gcs-pubsub-publishing" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
}

# resource "google_service_account" "account" {
#   account_id   = "project-service-account"
#   display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
# }

# resource "google_project_iam_member" "invoking" {
#   project = var.project_id
#   role    = "roles/run.invoker"
#   member  = "serviceAccount:${google_service_account.account.email}"
#   depends_on = [google_project_iam_member.gcs-pubsub-publishing]
# }

# resource "google_project_iam_member" "event-receiving" {
#   project = var.project_id
#   role    = "roles/eventarc.eventReceiver"
#   member  = "serviceAccount:${google_service_account.account.email}"
#   depends_on = [google_project_iam_member.invoking]
# }

# resource "google_project_iam_member" "artifactregistry-reader" {
#   project = var.project_id
#   role     = "roles/artifactregistry.reader"
#   member   = "serviceAccount:${google_service_account.account.email}"
#   depends_on = [google_project_iam_member.event-receiving]
# }




resource "google_cloudfunctions2_function" "function" {
  name = "Cloud-function-trigger-using-terraform-gen-2"
  location = var.region
  description = "Cloud function gen2 trigger using terraform "

  build_config {
    runtime     = "python39"
    entry_point = "helloGET" 
    environment_variables = {
      BUILD_CONFIG_TEST = "build_test"
    }
    source {
      storage_source {
        bucket = google_storage_bucket.Cloud_function_bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count  = 3
    min_instance_count = 1
    available_memory    = "256M"
    timeout_seconds     = 60
    environment_variables = {
        SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email = var.service_account_email
  }

  event_trigger {
    trigger_region = var.region
    event_type = "google.cloud.storage.object.v1.finalized"
    retry_policy = "RETRY_POLICY_RETRY"
    service_account_email = var.service_account_email
    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.input_bucket.name
    }
  }
  depends_on = [
    # google_project_iam_member.event-receiving,
    # google_project_iam_member.artifactregistry-reader,
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.zip,
    google_project_service.cloud_build_api,
    google_project_service.cloud_functions_api,
    google_project_service.run_api,
    google_project_service.artifactregistry_api
  ]
}