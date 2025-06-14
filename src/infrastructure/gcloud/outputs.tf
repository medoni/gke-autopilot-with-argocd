
# Cluster information
output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.autopilot.name
}

output "cluster_location" {
  description = "Location of the GKE cluster"
  value       = google_container_cluster.autopilot.location
}

output "cluster_endpoint" {
  description = "Endpoint for the GKE cluster"
  value       = google_container_cluster.autopilot.endpoint
  sensitive   = true
}

# ArgoCD information
output "argocd_url" {
  description = "URL to access ArgoCD UI"
  value       = "https://${var.argocd_domain}"
}

output "argocd_admin_password_command" {
  description = "Command to retrieve ArgoCD admin password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}

# DNS information
output "dns_zone_name" {
  description = "Name of the DNS zone"
  value       = data.google_dns_managed_zone.dns_zone.name
}

output "argocd_ip_address" {
  description = "IP address assigned to ArgoCD ingress"
  value       = data.kubernetes_ingress_v1.argocd_server.status.0.load_balancer.0.ingress.0.ip
}
