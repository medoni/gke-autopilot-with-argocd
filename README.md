# ArgoCD on GKE Autopilot with Terraform
Quick setup for Google Kubernetes Engine (GKE) Autopilot cluster with ArgoCD using Terraform.

## What You Get

- GKE Autopilot cluster
- ArgoCD for GitOps
- HTTPS with Google Managed SSL certificates
- Infrastructure as Code with Terraform

## Prerequisites

- Google Cloud account with billing enabled
- `gcloud` CLI installed and authenticated
- `terraform` installed
- `kubectl` installed

## Quick Start

1. Clone and configure:
    ```bash
    git clone <this-repo>
    cd <this-repo>/src/infrastructure/gcloud
    # edit default.tfvars
    ```
2. Deploy
   ```bash
   terraform init
   terraform plan --var-file=default.tfvars
   terraform apply --var-file=default.tfvars
   ```
3. Access ArgoCD
   ```bash
   # Get admin password
   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=&quot;{.data.password}&quot; | base64 -d

   # Access UI at: https://argocd.your-domain.com
   ```

## Cleanup
```bash
terraform destroy --var-file=default.tfvars
```

## Related Articles
- Comming soon

