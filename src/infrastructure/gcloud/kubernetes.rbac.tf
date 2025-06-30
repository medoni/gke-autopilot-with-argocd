resource "kubernetes_namespace" "project_namespaces" {
  for_each = local.rbac_config.namespaces

  metadata {
    name = each.key
    labels = {
      "managed-by" = "terraform"
      "rbac-enabled" = "true"
    }
  }
}

# Reader Role
resource "kubernetes_role" "reader" {
  for_each = local.rbac_config.namespaces

  metadata {
    namespace = each.key
    name      = "reader"
  }

  rule {
    api_groups = ["", "apps", "extensions"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch"]
  }
}

# Contributor Role
resource "kubernetes_role" "contributor" {
  for_each = local.rbac_config.namespaces

  metadata {
    namespace = each.key
    name      = "contributor"
  }

  rule {
    api_groups = ["", "apps", "extensions"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch"]
  }

  # Conditional delete permissions based on policy
  dynamic "rule" {
    for_each = var.rbac_policy == "flexible" ? [1] : []
    content {
      api_groups = ["", "apps", "extensions"]
      resources  = ["*"]
      verbs      = ["delete"]
    }
  }

  # Strict policy: deny delete for PVCs and StatefulSets
  dynamic "rule" {
    for_each = var.rbac_policy == "strict" ? [1] : []
    content {
      api_groups     = [""]
      resources      = ["persistentvolumeclaims"]
      verbs          = ["delete"]
      resource_names = []
    }
  }

  dynamic "rule" {
    for_each = var.rbac_policy == "strict" ? [1] : []
    content {
      api_groups     = ["apps"]
      resources      = ["statefulsets"]
      verbs          = ["delete"]
      resource_names = []
    }
  }
}

# Admin Role
resource "kubernetes_role" "admin" {
  for_each = local.rbac_config.namespaces

  metadata {
    namespace = each.key
    name      = "admin"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

# RoleBindings for Reader
resource "kubernetes_role_binding" "readers" {
  for_each = {
    for ns_user in flatten([
      for namespace, users in local.rbac_config.namespaces : [
        for user in users.readers : {
          namespace = namespace
          user      = user
        }
      ]
    ]) : "${ns_user.namespace}-${ns_user.user}-reader" => ns_user
  }

  metadata {
    name      = "reader-${each.value.user}"
    namespace = each.value.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "reader"
  }

  subject {
    kind = "User"
    name = each.value.user
  }
}

# RoleBindings ffor Contributors
resource "kubernetes_role_binding" "contributors" {
  for_each = {
    for ns_user in flatten([
      for namespace, users in local.rbac_config.namespaces : [
        for user in users.contributors : {
          namespace = namespace
          user      = user
        }
      ]
    ]) : "${ns_user.namespace}-${ns_user.user}-contributor" => ns_user
  }

  metadata {
    name      = "contributor-${each.value.user}"
    namespace = each.value.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "contributor"
  }

  subject {
    kind = "User"
    name = each.value.user
  }
}

# RoleBindings for Admins
resource "kubernetes_role_binding" "admins" {
  for_each = {
    for ns_user in flatten([
      for namespace, users in local.rbac_config.namespaces : [
        for user in users.admins : {
          namespace = namespace
          user      = user
        }
      ]
    ]) : "${ns_user.namespace}-${ns_user.user}-admin" => ns_user
  }

  metadata {
    name      = "admin-${each.value.user}"
    namespace = each.value.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "admin"
  }

  subject {
    kind = "User"
    name = each.value.user
  }
}
