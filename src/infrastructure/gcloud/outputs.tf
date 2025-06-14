output "cluster_id" {
  description = "The unique identifier of the cluster"
  value       = google_container_cluster.autopilot.id
}

output "cluster_endpoint" {
  description = "The IP address of the cluster's Kubernetes master"
  value       = google_container_cluster.autopilot.endpoint
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster"
  value       = base64decode(google_container_cluster.autopilot.master_auth[0].cluster_ca_certificate)
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the cluster"
  value       = google_container_cluster.autopilot.location
}
