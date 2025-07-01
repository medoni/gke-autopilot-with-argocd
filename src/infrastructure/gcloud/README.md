# ArgoCD on GKE Autopilot with Terraform

## Features

- **GKE Autopilot** with Google-managed nodes and security
- **ArgoCD** for GitOps workflow management
- **Google Managed SSL** certificates
- **Workload Identity** for secure pod-to-GCP authentication

## Usage
```bash
# edit default.tfvars
terraform init
terraform plan --var-file=default.tfvars
terraform apply --var-file=default.tfvars
```

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_domain"></a> [argocd\_domain](#input\_argocd\_domain) | Public domain for argocd | `string` | n/a | yes |
| <a name="input_argocd_use_spot_instances"></a> [argocd\_use\_spot\_instances](#input\_argocd\_use\_spot\_instances) | True/false to use Google Clouds spot instances. | `bool` | n/a | yes |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The zone name (DNS) to add sub domains | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_argocd_resources"></a> [argocd\_resources](#input\_argocd\_resources) | Resource limits and requests for ArgoCD components | <pre>object({<br/>    server = object({<br/>      requests = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>    })<br/>    controller = object({<br/>      requests = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>    })<br/>    dex = object({<br/>      requests = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>    })<br/>    redis = object({<br/>      requests = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>    })<br/>    repo_server = object({<br/>      requests = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>      limits = object({<br/>        cpu    = string<br/>        memory = string<br/>      })<br/>    })<br/>  })</pre> | <pre>{<br/>  "controller": {<br/>    "limits": {<br/>      "cpu": "250m",<br/>      "memory": "256Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "100m",<br/>      "memory": "128Mi"<br/>    }<br/>  },<br/>  "dex": {<br/>    "limits": {<br/>      "cpu": "50m",<br/>      "memory": "64Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "25m",<br/>      "memory": "32Mi"<br/>    }<br/>  },<br/>  "redis": {<br/>    "limits": {<br/>      "cpu": "100m",<br/>      "memory": "128Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "50m",<br/>      "memory": "64Mi"<br/>    }<br/>  },<br/>  "repo_server": {<br/>    "limits": {<br/>      "cpu": "200m",<br/>      "memory": "256Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "100m",<br/>      "memory": "128Mi"<br/>    }<br/>  },<br/>  "server": {<br/>    "limits": {<br/>      "cpu": "100m",<br/>      "memory": "128Mi"<br/>    },<br/>    "requests": {<br/>      "cpu": "50m",<br/>      "memory": "64Mi"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_argocd_version"></a> [argocd\_version](#input\_argocd\_version) | Version of ArgoCD to deploy | `string` | `"8.0.17"` | no |
| <a name="input_cluster_ipv4_cidr_block"></a> [cluster\_ipv4\_cidr\_block](#input\_cluster\_ipv4\_cidr\_block) | The IP address range for pods in the cluster | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the GKE cluster | `string` | `"gke-autopilot-cluster"` | no |
| <a name="input_network"></a> [network](#input\_network) | The VPC network to host the cluster | `string` | `"default"` | no |
| <a name="input_node_service_account"></a> [node\_service\_account](#input\_node\_service\_account) | The Google Cloud Platform Service Account to be used by the node VMs | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the GKE cluster will be created | `string` | `"europe-west3"` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel of the GKE cluster | `string` | `"REGULAR"` | no |
| <a name="input_services_ipv4_cidr_block"></a> [services\_ipv4\_cidr\_block](#input\_services\_ipv4\_cidr\_block) | The IP address range for services in the cluster | `string` | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | The subnetwork to host the cluster | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_argocd_admin_password_command"></a> [argocd\_admin\_password\_command](#output\_argocd\_admin\_password\_command) | Command to retrieve ArgoCD admin password |
| <a name="output_argocd_ip_address"></a> [argocd\_ip\_address](#output\_argocd\_ip\_address) | IP address assigned to ArgoCD ingress |
| <a name="output_argocd_url"></a> [argocd\_url](#output\_argocd\_url) | URL to access ArgoCD UI |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for the GKE cluster |
| <a name="output_cluster_location"></a> [cluster\_location](#output\_cluster\_location) | Location of the GKE cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the GKE cluster |
| <a name="output_dns_zone_name"></a> [dns\_zone\_name](#output\_dns\_zone\_name) | Name of the DNS zone |
<!-- END_TF_DOCS -->
