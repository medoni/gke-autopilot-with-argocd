resource "helm_release" "argocd" {
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  verify           = false
  version          = var.argocd_version
  wait             = false

  set {
    name = "global.domain"
    value = var.argocd_domain
  }

  set {
    name = "server.ingress.enabled"
    value = "true"
  }

  set {
    name = "server.ingress.controller"
    value = "gke"
  }

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
