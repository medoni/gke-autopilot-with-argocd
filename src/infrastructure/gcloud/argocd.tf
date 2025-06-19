resource "helm_release" "argocd" {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  verify           = false
  version          = var.argocd_version
  wait             = false

  values = [
    yamlencode({
      global = {
        domain = var.argocd_domain
      }

      configs = {
        params = {
          "server.insecure" = true
        }

        rbac = {
          "policy.csv" = file("argocd.rbac.csv")
          scopes = "[email]"
        }

        cm = {
          "dex.config" = yamlencode({
            connectors = [{
              type = "oidc"
              id = "google"
              name = "Google"
              config = {
                issuer = "https://accounts.google.com"
                clientID = var.google_auth_client_id
                clientSecret = "$google.clientSecret"
                requestedScopes = ["openid", "profile", "email"]
                requestedIDTokenClaims = {
                  email = {
                    essential = true
                  }
                }
              }
            }]
          })
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
  # When deploying ArgoCD using Helm, I intentionally set the lifecycle on the helm_release resource to ignore all changes.
  # This is because all future updates to ArgoCD are managed using ArgoCD itself — keeping the process consistent with the GitOps philosophy.
  # lifecycle {
  #   ignore_changes = all # Just bootstrap & forget and let ArgoCD do it's job.
  # }
}

resource "kubernetes_secret" "argocd_repo_creds" {
  metadata {
    name      = "git-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    url      = var.argocd_repo_git_url
    username = "git"
    password = var.argocd_repo_git_pat
  }

  depends_on = [
    helm_release.argocd
  ]
}

resource "kubernetes_secret" "google_oauth" {
  metadata {
    name      = "google-oauth-secret"
    namespace = "argocd"
  }

  data = {
    clientSecret = "placeholder"
  }

  depends_on = [
    google_container_cluster.autopilot
  ]

  lifecycle {
    ignore_changes = [data]
  }
}
