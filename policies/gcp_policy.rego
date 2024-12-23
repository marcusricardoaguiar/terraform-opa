package terraform.gcp_policy

####################
# Terraform Rules  #
####################

# Ensure no uniform_bucket_level_access disable for GCP storage buckets
violate[msg] if {
  resource := input.resource_changes[_]
  resource.type == "google_storage_bucket"
  resource.change.after.uniform_bucket_level_access == false
  msg := sprintf("Bucket '%s' must have bucket policy only enabled.", [resource.name])
}

# Ensure GCP Compute Instances use the 'e2-medium' machine type
violate[msg] if {
  resource := input.resource_changes[_]
  resource.type == "google_compute_instance"
  resource.change.after.machine_type != "e2-medium"
  msg := sprintf("Instance '%s' must use machine type 'e2-medium'.", [resource.change.after.name])
}

# Ensure GCP VPC subnets enables Private Access
violate[msg] if {
  resource := input.resource_changes[_]
  resource.type == "google_compute_subnetwork"
  resource.change.after.private_ip_google_access != true
  msg := sprintf("Subnetwork '%s' must enable private access.", [resource.change.after.name])
}
