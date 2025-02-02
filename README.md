# PVE terraform cloud-init

Use Terraform and YAML config to generate a `cloud-init.yml` for creating a PVE VM.

## setup

### add terraform role & user

```sh
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

> Ensure the "Snippets" content type is enabled on the target datastore in Proxmox before applying the configuration below.

### install terraform

```sh
wget https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_amd64.zip
unzip terraform_1.10.5_linux_amd64.zip terraform
mv terraform ~/.local/bin/terraform
```

### init terraform workspace

```sh
terraform init # or terraform init -upgrade
```

### apply & destroy terraform config

```sh
terraform apply
# only apply VM
terraform apply -target=proxmox_virtual_environment_vm.ubuntu_vm
```

```sh
terraform destroy
# only destroy VM
terraform destroy -target=proxmox_virtual_environment_vm.ubuntu_vm
```

## config

modify `config.yml` and `./template/` yaml files
