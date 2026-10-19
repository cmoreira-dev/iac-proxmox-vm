# iac-proxmox-vm

Reusable OpenTofu/Terraform module: one Proxmox VM (bpg/proxmox) that a plan can never destroy or
reboot. Meant for adopting existing VMs by import, for example a Kubernetes node with a GPU passed
through.

Consumed through Terragrunt, one unit per VM:

```hcl
terraform {
  source = "git::https://github.com/cmoreira-dev/iac-proxmox-vm.git//module?ref=v0.1.0"
}

inputs = {
  proxmox_endpoint = "https://<host>:8006/"   # the token comes from TF_VAR_proxmox_api_token
  node_name        = "<node>"
  vm_id            = 100
  name             = "<vm name>"
  cpu              = { cores = 4 }
  memory_mb        = 8192
}
```

See [docs/index.md](docs/index.md).
