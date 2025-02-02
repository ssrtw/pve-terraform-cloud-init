# terraform plan -target=proxmox_virtual_environment_file.user_data_cloud_config

locals {
  ci      = templatefile("${local.tmpldir}/cloud-init.yml", local.config)
  ci_yaml = yamldecode(local.ci)
  ci_user = [
    yamldecode(
      templatefile("${local.tmpldir}/users.yml", local.config)
    )
  ]

  ci_user_update = concat(local.ci_yaml["users"], local.ci_user)

  append_runcmds = flatten([
    for filename in local.config.runcmds :
    yamldecode(
      templatefile("${local.tmpldir}/runcmd/${filename}.yml", local.config)
    )
  ])

  ci_runcmd_update = concat(local.ci_yaml["runcmd"], local.append_runcmds)

  ci_userdata = "#cloud-config\n${yamlencode(
    merge(
      local.ci_yaml,
      {
        users  = local.ci_user_update
        runcmd = local.ci_runcmd_update
      }
    )
  )}"
}
