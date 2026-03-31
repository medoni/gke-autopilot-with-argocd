locals {
  argocd_rbac_csv = join("\n", concat(
    # Policy Header
    ["p, role:admin, applications, *, */*, allow"],
    ["p, role:admin, clusters, *, *, allow"],
    ["p, role:admin, repositories, *, *, allow"],

    # Namespace-specific policies
    flatten([
      for namespace, users in local.rbac_config.namespaces : [
        # Reader policies
        [for user in users.readers : "p, role:${namespace}-reader, applications, get, ${namespace}/*, allow"],
        [for user in users.readers : "p, role:${namespace}-reader, applications, sync, ${namespace}/*, deny"],

        # Contributor policies
        [for user in users.contributors : "p, role:${namespace}-contributor, applications, *, ${namespace}/*, allow"],
        [for user in users.contributors : var.rbac_policy == "strict" ?
          "p, role:${namespace}-contributor, applications, delete, ${namespace}/*, deny" :
          "p, role:${namespace}-contributor, applications, delete, ${namespace}/*, allow"],

        # Admin policies
        [for user in users.admins : "p, role:${namespace}-admin, applications, *, ${namespace}/*, allow"],

        # Group mappings
        [for user in users.readers : "g, ${user}, role:${namespace}-reader"],
        [for user in users.contributors : "g, ${user}, role:${namespace}-contributor"],
        [for user in users.admins : "g, ${user}, role:${namespace}-admin"]
      ]
    ])
  ))
}
