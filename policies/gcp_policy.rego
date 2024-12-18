package terraform.gcp_policy

# Ensure no public access for GCP storage buckets
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_storage_bucket"
  resource.change.after.iam_configuration.bucket_policy_only.enabled == false
  msg = sprintf("Bucket '%s' must have bucket policy only enabled.", [resource.change.after.name])
}

# Ensure GCP Compute Instances use the 'e2-medium' machine type
deny[msg] {
  resource := input.resource_changes[_]
  resource.type == "google_compute_instance"
  resource.change.after.machine_type != "e2-medium"
  msg = sprintf("Instance '%s' must use machine type 'e2-medium'.", [resource.change.after.name])
}
