data "google_dns_managed_zone" "dns_zone" {
  name = var.dns_zone_name
}

resource "google_dns_record_set" "argocd" {
  name         = "${var.argocd_domain}."
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.dns_zone.name

  rrdatas = [data.kubernetes_ingress_v1.argocd_server.status.0.load_balancer.0.ingress.0.ip]

  depends_on = [helm_release.argocd]
}

# Get the ArgoCD server ingress details
data "kubernetes_ingress_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}
