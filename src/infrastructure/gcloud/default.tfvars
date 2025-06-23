# Required values
project_id = "gke-autopilot-462518"

# Optional values with defaults shown
region = "europe-west3"  # Frankfurt
cluster_name = "gke-autopilot-cluster"

# Network configuration (default VPC and subnet shown)
network = "default"
subnetwork = "default"

# Optional: Override these if you need specific CIDR ranges
# cluster_ipv4_cidr_block = "10.100.0.0/16"
# services_ipv4_cidr_block = "10.200.0.0/16"

# Cluster configuration
release_channel = "REGULAR"  # Other options: RAPID, STABLE

# Optional: Specify a custom service account for nodes
# node_service_account = "your-service-account@your-project.iam.gserviceaccount.com"

dns_zone_name = "gke-autopilot"
argocd_domain = "argocd.gke-auto.squirreldev.de"
