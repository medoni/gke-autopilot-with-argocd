# GKE Autopilot with Spot Instances Terraform Module

This Terraform module deploys a Google Kubernetes Engine (GKE) cluster in Autopilot mode with spot instances for cost optimization. The module is designed to provide a production-ready Kubernetes cluster with sensible defaults while maintaining flexibility for customization.

## Features

- 🚀 GKE Autopilot mode for automated management
- 💰 Spot instances by default for cost optimization
- 🔄 Automatic node repairs and upgrades
- 📈 Vertical pod autoscaling enabled
- 🌍 Default region in Frankfurt (europe-west3)
- 🔧 Configurable maintenance window (default: 3 AM)

## Prerequisites

- Terraform >= 1.0
- Google Cloud SDK
- A Google Cloud Project with required APIs enabled:
  - Container API (container.googleapis.com)
  - Compute Engine API (compute.googleapis.com)

## Usage

1. Configure your Google Cloud credentials:
```powershell
# Set your Google Cloud project ID
$env:GOOGLE_PROJECT = "your-project-id"
# Authenticate with Google Cloud
gcloud auth application-default login
```

2. Create a new Terraform configuration file (e.g., `main.tf`):
```hcl
module "gke_autopilot" {
  source     = "./src/infrastructure/gcloud"
  project_id = "your-project-id"

  # Optional: Override defaults
  region       = "europe-west3"
  cluster_name = "my-gke-cluster"
}
```

3. Initialize and apply the Terraform configuration:
```powershell
# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| project_id | The GCP project ID | string | - | yes |
| region | The region where the GKE cluster will be created | string | europe-west3 | no |
| cluster_name | The name of the GKE cluster | string | gke-autopilot-cluster | no |
| network | The VPC network to host the cluster | string | default | no |
| subnetwork | The subnetwork to host the cluster | string | default | no |
| release_channel | The release channel of the GKE cluster (RAPID, REGULAR, STABLE) | string | REGULAR | no |
| node_service_account | The Google Cloud Platform Service Account for nodes | string | null | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The unique identifier of the cluster |
| cluster_endpoint | The IP address of the cluster's Kubernetes master |
| cluster_ca_certificate | The public certificate that is the root of trust for the cluster |
| cluster_location | The location of the cluster |

## Maintenance Window

The cluster is configured with a daily maintenance window at 3 AM. You can modify this in the `main.tf` file if needed.

## Security

- The cluster uses VPC-native networking
- Automatic node upgrades and repairs are enabled
- Certificate-based authentication
- Service account support for node pools

## Cost Optimization

This module uses spot instances by default to optimize costs. While this provides significant cost savings, be aware that spot instances can be preempted. The Autopilot mode helps manage this by automatically handling node pool management and scaling.

## Contributing

Feel free to submit issues and enhancement requests!

## License

This module is licensed under the MIT License.
