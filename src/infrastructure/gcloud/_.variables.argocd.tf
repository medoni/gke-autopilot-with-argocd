variable "argocd_domain" {
  description = "Public domain for argocd"
  type        = string
}

variable "argocd_version" {
  description = "Version of ArgoCD to deploy"
  type        = string
  default     = "8.0.17"
}

variable "argocd_use_spot_instances" {
  description = "True/false to use Google Clouds spot instances."
  type        = bool
}

variable "argocd_resources" {
  description = "Resource limits and requests for ArgoCD components"
  type = object({
    server = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
    controller = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
    dex = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
    redis = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
    repo_server = object({
      requests = object({
        cpu    = string
        memory = string
      })
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })
  default = {
    server = {
      requests = {
        cpu    = "50m"
        memory = "64Mi"
      }
      limits = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
    controller = {
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
      limits = {
        cpu    = "250m"
        memory = "256Mi"
      }
    }
    dex = {
      requests = {
        cpu    = "25m"
        memory = "32Mi"
      }
      limits = {
        cpu    = "50m"
        memory = "64Mi"
      }
    }
    redis = {
      requests = {
        cpu    = "50m"
        memory = "64Mi"
      }
      limits = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
    repo_server = {
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
      limits = {
        cpu    = "200m"
        memory = "256Mi"
      }
    }
  }
}
