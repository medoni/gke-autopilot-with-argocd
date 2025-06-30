locals {
  rbac_config = yamldecode(file("${path.module}/config/rbac-policy.yaml"))
}
