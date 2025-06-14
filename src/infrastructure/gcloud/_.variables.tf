variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where the GKE cluster will be created"
  type        = string
  default     = "europe-west3"  # Frankfurt region
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
  default     = "gke-autopilot-cluster"
}

variable "network" {
  description = "The VPC network to host the cluster"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster"
  type        = string
  default     = "default"
}

variable "cluster_ipv4_cidr_block" {
  description = "The IP address range for pods in the cluster"
  type        = string
  default     = null  # Auto-assigned by GCP
}

variable "services_ipv4_cidr_block" {
  description = "The IP address range for services in the cluster"
  type        = string
  default     = null  # Auto-assigned by GCP
}

variable "release_channel" {
  description = "The release channel of the GKE cluster"
  type        = string
  default     = "REGULAR"
  validation {
    condition     = contains(["RAPID", "REGULAR", "STABLE"], var.release_channel)
    error_message = "Release channel must be one of: RAPID, REGULAR, STABLE."
  }
}

variable "node_service_account" {
  description = "The Google Cloud Platform Service Account to be used by the node VMs"
  type        = string
  default     = null  # Will use the default compute service account
}

variable "dns_zone_id" {
  description = "The zone id (DNS) to add sub domains"
  type        = string
}

variable "argocd_domain" {
  description = "Public domain for argocd"
  type        = string
}

variable "argocd_version" {
  description = "Version of ArgoCD to deploy"
  type        = string
  default     = "8.0.17"
}

variable "argocd_repo_git_url" {
  description = "..." # TODO:
  type        = string
  default     = "https://github.com/example"
}

variable "argocd_repo_git_pat" {
  description = "..." # TODO:
  type        = string
  sensitive   = true
  default     = "pat1234"
}
