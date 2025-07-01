resource "helm_release" "argocd" {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  verify           = false
  version          = var.argocd_version

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
        nodeSelector = {}        
        affinity = var.argocd_use_spot_instances ? {
          nodeAffinity = {
            preferredDuringSchedulingIgnoredDuringExecution = [
              {
                weight = 100
                preference = {
                  matchExpressions = [
                    {
                      key = "cloud.google.com/gke-spot"
                      operator = "In"
                      values = ["true"]
                    }
                  ]
                }
              }
            ]
          }
        } : {}
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }

      server = {
        resources = {
          requests = var.argocd_resources.server.requests
          limits   = var.argocd_resources.server.limits
        }

        ingress = {
          enabled = true
          controller = "gke"

          gke = {
            backendConfig = {
              healthCheck = {
                type = "http"
                checkIntervalSec = 30
                timeoutSec = 5
                healthyThreshold = 1
                unhealthyThreshold = 2
              }
            }

            managedCertificate = {
              enabled = true
            }
          }
        }
      }

      controller = {
        resources = {
          requests = var.argocd_resources.controller.requests
          limits   = var.argocd_resources.controller.limits
        }
      }

      dex = {
        resources = {
          requests = var.argocd_resources.dex.requests
          limits   = var.argocd_resources.dex.limits
        }
      }

      redis = {
        resources = {
          requests = var.argocd_resources.redis.requests
          limits   = var.argocd_resources.redis.limits
        }
      }

      repoServer = {
        resources = {
          requests = var.argocd_resources.repo_server.requests
          limits   = var.argocd_resources.repo_server.limits
        }
      }
    })
  ]

  depends_on = [
    google_container_cluster.autopilot
  ]
}
