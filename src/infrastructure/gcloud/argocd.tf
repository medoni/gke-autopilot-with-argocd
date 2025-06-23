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
      }

      configs = {
        params = {
          # Disable internal TLS since the GKE ingress handles TLS termination
          "server.insecure" = true
        }
      }

      server = {
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

            # Enable Google Managed SSL Certificate
            managedCertificate = {
              enabled = true
            }
          }
        }
      }
    })
  ]

  depends_on = [
    google_container_cluster.autopilot
  ]
}
