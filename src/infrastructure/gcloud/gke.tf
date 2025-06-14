resource "google_container_cluster" "autopilot" {
  name             = var.cluster_name
  location         = var.region
  project          = var.project_id

  # Enable Autopilot mode
  enable_autopilot = true

  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork

  # IP allocation policy for VPC-native cluster
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  release_channel {
    channel = var.release_channel
  }

  # Spot VM configuration
  cluster_autoscaling {
    auto_provisioning_defaults {
      management {
        auto_repair  = true
        auto_upgrade = true
      }
      # Use spot VMs by default
      service_account = var.node_service_account
    }
  }

  node_config {
    spot = true
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"  # Maintenance window at 3 AM
    }
  }

  vertical_pod_autoscaling {
    enabled = true
  }
}
