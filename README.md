# GKE Autopilot with Spot Instances Terraform Module

> [!NOTE]
> This README is automatically generated using GitHub Copilot with Claude Sonnet 3.5.

> [!WARNING]
> 🚧 This project is currently under active development and is not yet ready for production use. Features may be incomplete, and breaking changes can occur without notice. Use at your own risk.

This Terraform module deploys a Google Kubernetes Engine (GKE) cluster in Autopilot mode with spot instances for cost optimization and integrates ArgoCD for GitOps practices. The module is designed to provide a production-ready Kubernetes cluster with sensible defaults while maintaining flexibility for customization.

## Features

- 🚀 GKE Autopilot mode for automated management
- 💰 Spot instances by default for cost optimization
- 🔄 Automatic node repairs and upgrades
- 📈 Vertical pod autoscaling enabled
- 🌍 Default region in Frankfurt (europe-west3)
- 🔧 Configurable maintenance window (default: 3 AM)
- 🛥️ ArgoCD integration for GitOps workflow
- 🌐 Automatic DNS configuration
- 🔒 Managed SSL certificates
- 🚦 Health checks and HTTPS redirection

## Prerequisites

- Terraform >= 1.0
- Google Cloud SDK
- A Google Cloud Project with required APIs enabled:
  - Container API (container.googleapis.com)
  - Compute Engine API (compute.googleapis.com)
  - DNS API (dns.googleapis.com)
- A GitHub repository for GitOps (for ArgoCD)
- A domain name for ArgoCD UI (optional)

## Architecture

This module sets up:
1. A GKE Autopilot cluster with spot instances
2. ArgoCD deployment with Helm
3. DNS configuration for ArgoCD UI (optional)
4. Managed SSL certificates for secure access
5. Health checks and HTTPS redirection for the ingress

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
| argocd_version | Version of ArgoCD to deploy | string | 8.0.17 | no |
| argocd_domain | Domain for ArgoCD UI access | string | - | yes |
| dns_zone_id | The ID of the DNS zone for ArgoCD domain | string | - | yes |
| argocd_repo_git_url | URL of the Git repository for ArgoCD | string | - | yes |
| argocd_repo_git_pat | Personal Access Token for Git repository | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The unique identifier of the cluster |
| cluster_endpoint | The IP address of the cluster's Kubernetes master |
| cluster_ca_certificate | The public certificate that is the root of trust for the cluster |
| cluster_location | The location of the cluster |

## Maintenance Window

The cluster is configured with a daily maintenance window at 3 AM. You can modify this in the `main.tf` file if needed.

## ArgoCD Access

After the cluster is deployed, ArgoCD will be accessible through:

1. Domain access (if configured):
   - Access ArgoCD UI at: `https://<your-argocd-domain>`
   - SSL is automatically managed through GCP-managed certificates

2. Port forwarding (without domain):
```powershell
kubectl port-forward service/argocd-server -n argocd 8080:443
```
Then access ArgoCD UI at: `http://localhost:8080`

To get the initial admin password:
```powershell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | ConvertFrom-Base64
```

## GitOps Setup

ArgoCD is configured with:
- Automatic repository credentials setup
- Health checks for the UI
- HTTPS redirection
- Managed SSL certificates (when domain is configured)

To add applications to ArgoCD, create ApplicationSet or Application resources in your Git repository.

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
