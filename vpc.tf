# module "vpc" {
#   source       = "terraform-google-modules/network/google"
#   version      = "7.1.0"
#   project_id   = var.project_id
#   network_name = "terraform-vpc"
#   routing_mode = "REGIONAL" #REGIONAL/GLOBAL

#   subnets = [
#     {
#       subnet_name   = "eu-west-subnet"
#       subnet_ip     = "10.10.10.0/28"
#       subnet_region = var.region
#     }
#   ]
# }