# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.Cloud_function_bucket.name
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.source
  ]
}

# # Create the Cloud function triggered by a `Finalize` event on the bucket
# resource "google_cloudfunctions_function" "Cloud_function" {
#   name                  = "Cloud-function-trigger-using-terraform"
#   description           = "Cloud function trigger using terraform"
#   runtime               = "python39"
#   project               = var.project_id
#   region                = var.region
#   source_archive_bucket = google_storage_bucket.Cloud_function_bucket.name
#   source_archive_object = google_storage_bucket_object.zip.name
#   entry_point           = "helloGET"
#   event_trigger {
#     event_type = "google.storage.object.finalize"
#     resource   = "input-${var.project_id}"
#   }
#   docker_repository = "projects/${var.project_id}/locations/${var.region}/repositories/${google_artifact_registry_repository.artifactory_repository.name}"
#   # vpc_connector = "projects/${var.project_id}/locations/${var.region}/connectors/connector-serverless"
#   depends_on = [
#     google_storage_bucket.Cloud_function_bucket,
#     google_storage_bucket_object.zip,
#     # google_project_service.services,
#   ]
# }

















resource "google_cloudfunctions2_function" "Cloud_function" {
  name        = "Cloud-function-trigger-using-terraform-gen-2"
  location    = var.region
  project     = var.project_id
  description = "Cloud function gen2 trigger using terraform "

  build_config {
    runtime           = "python39"
    entry_point       = "helloGET"
    docker_repository = "projects/${var.project_id}/locations/${var.region}/repositories/${google_artifact_registry_repository.artifactory_repository.name}"
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
    max_instance_count = 3
    min_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    environment_variables = {
      SERVICE_CONFIG_TEST = "config_test"
    }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision = true
    service_account_email          = var.service_account_email
  }
  event_trigger {
    trigger_region        = var.region
    event_type            = "google.cloud.storage.object.v1.finalized"
    retry_policy          = "RETRY_POLICY_RETRY"
    service_account_email = var.service_account_email
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.input_bucket.name
    }
  }
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.zip
  ]
}
############################################################








# # IAM entry for all users to invoke the function
# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.Cloud_function.project
#   region         = google_cloudfunctions_function.Cloud_function.region
#   cloud_function = google_cloudfunctions_function.Cloud_function.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }





### google_cloudfunctions2_function 

# data "google_storage_project_service_account" "gcs_account" {
# }

# resource "google_project_iam_member" "gcs-pubsub-publishing" {
#   project = var.project_id
#   role    = "roles/pubsub.publisher"
#   member  = "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"
# }

# # resource "google_service_account" "account" {
# #   account_id   = "project-service-account"
# #   display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
# # }

# # resource "google_project_iam_member" "invoking" {
# #   project = var.project_id
# #   role    = "roles/run.invoker"
# #   member  = "serviceAccount:${google_service_account.account.email}"
# #   depends_on = [google_project_iam_member.gcs-pubsub-publishing]
# # }

# # resource "google_project_iam_member" "event-receiving" {
# #   project = var.project_id
# #   role    = "roles/eventarc.eventReceiver"
# #   member  = "serviceAccount:${google_service_account.account.email}"
# #   depends_on = [google_project_iam_member.invoking]
# # }

# # resource "google_project_iam_member" "artifactregistry-reader" {
# #   project = var.project_id
# #   role     = "roles/artifactregistry.reader"
# #   member   = "serviceAccount:${google_service_account.account.email}"
# #   depends_on = [google_project_iam_member.event-receiving]
# # }




# resource "google_cloudfunctions2_function" "function" {
#   name        = "Cloud-function-trigger-using-terraform-gen-2"
#   location    = var.region
#   description = "Cloud function gen2 trigger using terraform "

#   build_config {
#     runtime     = "python39"
#     entry_point = "helloGET"
#     environment_variables = {
#       BUILD_CONFIG_TEST = "build_test"
#     }
#     source {
#       storage_source {
#         bucket = google_storage_bucket.Cloud_function_bucket.name
#         object = google_storage_bucket_object.zip.name
#       }
#     }
#   }

#   service_config {
#     max_instance_count = 3
#     min_instance_count = 1
#     available_memory   = "256M"
#     timeout_seconds    = 60
#     environment_variables = {
#       SERVICE_CONFIG_TEST = "config_test"
#     }
#     ingress_settings               = "ALLOW_INTERNAL_ONLY"
#     all_traffic_on_latest_revision = true
#     service_account_email          = var.service_account_email
#   }

#   event_trigger {
#     trigger_region        = var.region
#     event_type            = "google.cloud.storage.object.v1.finalized"
#     retry_policy          = "RETRY_POLICY_RETRY"
#     service_account_email = var.service_account_email
#     event_filters {
#       attribute = "bucket"
#       value     = google_storage_bucket.input_bucket.name
#     }
#   }
#   depends_on = [
#     # google_project_iam_member.event-receiving,
#     # google_project_iam_member.artifactregistry-reader,
#     google_storage_bucket.Cloud_function_bucket,
#     google_storage_bucket_object.zip,
#     google_project_service.cloud_build_api,
#     google_project_service.cloud_functions_api,
#     google_project_service.run_api,
#     google_project_service.artifactregistry_api
#   ]
# }