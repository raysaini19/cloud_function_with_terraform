# resource "google_project_service" "servicenetworking" {
#   service            = "servicenetworking.googleapis.com"
#   disable_on_destroy = false
#   project            = var.project_id
# }

# # resource "google_compute_network" "network" {
# #   name                    = "my-network"
# #   auto_create_subnetworks = false
# #   depends_on = [google_project_service.servicenetworking]
# # }

# resource "google_compute_global_address" "private_ip_alloc" {
#   name          = "worker-pool-range"
#   project       = var.project_id
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 16
#   network       = module.vpc.network_id
# }

# resource "google_service_networking_connection" "worker_pool_conn" {
#   network                 = module.vpc.network_id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
#   depends_on = [
#     google_project_service.servicenetworking,
#     module.vpc
#   ]
# }

# resource "google_cloudbuild_worker_pool" "pool" {
#   name     = "cloudfunction-worker-pool"
#   location = var.region
#   project  = var.project_id
#   worker_config {
#     disk_size_gb   = 0
#     machine_type   = "e2-standard-4"
#     no_external_ip = false
#   }
#   network_config {
#     peered_network = module.vpc.network_id
#   }
#   depends_on = [
#     google_service_networking_connection.worker_pool_conn
#   ]
# }