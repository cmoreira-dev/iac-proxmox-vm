# One Proxmox VM, meant for VMs that already exist and must never be destroyed or rebooted by a
# plan (for example a Kubernetes node with a GPU passed through). Adopt by import:
# `proxmox_virtual_environment_vm.this` id `<node>/<vm_id>`.
#
# The provider block lives here on purpose: a Terragrunt account generates a single provider,
# and the cluster layers mix several (proxmox, talos, helm).
provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

# Temporary: states created before this module held the VM at `gpu_worker`. Drop this block in
# the next minor version, once every consumer has applied it.
moved {
  from = proxmox_virtual_environment_vm.gpu_worker
  to   = proxmox_virtual_environment_vm.this
}

resource "proxmox_virtual_environment_vm" "this" {
  node_name = var.node_name
  vm_id     = var.vm_id
  name      = var.name
  tags      = var.tags

  bios          = var.bios
  machine       = var.machine
  scsi_hardware = var.scsi_hardware
  boot_order    = var.boot_order

  on_boot             = var.on_boot
  reboot_after_update = var.reboot_after_update

  operating_system {
    type = var.os_type
  }

  cpu {
    cores   = var.cpu.cores
    sockets = var.cpu.sockets
    type    = var.cpu.type
    numa    = var.cpu.numa
  }

  memory {
    dedicated = var.memory_mb
  }

  dynamic "efi_disk" {
    for_each = var.efi_disk == null ? [] : [var.efi_disk]
    content {
      datastore_id = efi_disk.value.datastore_id
      type         = efi_disk.value.type
    }
  }

  dynamic "disk" {
    for_each = var.disks
    content {
      datastore_id = disk.value.datastore_id
      interface    = disk.value.interface
      size         = disk.value.size
      discard      = disk.value.discard
      iothread     = disk.value.iothread
    }
  }

  dynamic "network_device" {
    for_each = var.network_devices
    content {
      bridge      = network_device.value.bridge
      model       = network_device.value.model
      mac_address = network_device.value.mac_address
      firewall    = network_device.value.firewall
    }
  }

  dynamic "hostpci" {
    for_each = var.hostpci
    content {
      device = hostpci.value.device
      id     = hostpci.value.id
      pcie   = hostpci.value.pcie
      rombar = hostpci.value.rombar
    }
  }

  # A guard for stateful VMs: a plan can never destroy it. To retire the VM, drop it from state
  # (`tofu state rm`) or use a module version without this block.
  lifecycle {
    prevent_destroy = true
  }
}
