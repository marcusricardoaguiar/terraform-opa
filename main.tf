module "vpc" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v36.0.1"
  project_id = var.project_id
  name       = "test-opa-network"
  subnets = [
    {
      ip_cidr_range = "10.0.0.0/24"
      name          = "test-opa-subnet"
      region        = var.region
    }
  ]
}

# Basic resource to trigger the OPA policy
module "simple_vm" {
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-vm?ref=v36.0.1"
  project_id    = var.project_id
  zone          = var.region
  name          = "test-opa-vm"
  instance_type = "f1-micro"
  network_interfaces = [{
    network    = module.vpc.self_link
    subnetwork = module.vpc.subnet_self_links["${var.region}/test-opa-subnet"]
  }]
}

# Basic resource to trigger the OPA policy
resource "google_storage_bucket" "static_site" {
  name          = "test-opa-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
