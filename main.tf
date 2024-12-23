module "vpc" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/net-vpc?ref=v36.0.1"
  project_id = var.project_id
  name       = "test-opa-network"
  subnets = [
    {
      ip_cidr_range         = "10.0.0.0/24"
      name                  = "test-opa-subnet"
      region                = var.region
    },{
      ip_cidr_range         = "10.10.0.0/24"
      name                  = "test-opa-subnet-2"
      region                = var.region
      enable_private_access = false
    }
  ]
}

# Basic resource to trigger the OPA policy
module "simple_vm" {
  for_each      = {
    "test-opa-vm-1": {
      "type": "f1-micro"
    },
    "test-opa-vm-2": {
      "type": "e2-medium"
    }
  }
  source        = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/compute-vm?ref=v36.0.1"
  project_id    = var.project_id
  zone          = var.region
  name          = each.key
  instance_type = each.value.type
  network_interfaces = [{
    network    = module.vpc.self_link
    subnetwork = module.vpc.subnet_self_links["${var.region}/test-opa-subnet"]
  }]
}

# Basic resource to trigger the OPA policy
resource "google_storage_bucket" "static_site" {
  name          = "test-opa-bucket"
  location      = "US"
  force_destroy = false

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

# Basic second resource to trigger the OPA policy
resource "google_storage_bucket" "second_static_site" {
  name          = "test-second-opa-bucket"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = false

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
