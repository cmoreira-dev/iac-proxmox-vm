variable "proxmox_endpoint" {
  description = "Proxmox API URL, e.g. https://<host>:8006/ (LAN only)."
  type        = string
}

variable "proxmox_api_token" {
  description = "API token in the form user@realm!tokenid=secret. Pass it with TF_VAR_proxmox_api_token, never commit it."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (for a self-signed host certificate)."
  type        = bool
  default     = false
}

variable "node_name" {
  description = "Proxmox node that runs the VM."
  type        = string
}

variable "vm_id" {
  description = "VM id."
  type        = number
}

variable "name" {
  description = "VM name."
  type        = string
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "bios" {
  type    = string
  default = "seabios"
}

variable "machine" {
  type    = string
  default = "pc"
}

variable "scsi_hardware" {
  type    = string
  default = "virtio-scsi-single"
}

variable "boot_order" {
  description = "Boot order. Null keeps the provider default."
  type        = list(string)
  default     = null
}

variable "on_boot" {
  type    = bool
  default = true
}

variable "reboot_after_update" {
  description = "Reboot the VM when an update needs it. Keep false for VMs that must never be rebooted by a plan."
  type        = bool
  default     = true
}

variable "os_type" {
  type    = string
  default = "l26"
}

variable "cpu" {
  type = object({
    cores   = number
    sockets = optional(number, 1)
    type    = optional(string, "host")
    numa    = optional(bool, false)
  })
}

variable "memory_mb" {
  description = "Dedicated memory in MB."
  type        = number
}

variable "efi_disk" {
  description = "EFI vars disk (needed for bios = ovmf). Null for none."
  type = object({
    datastore_id = string
    type         = optional(string, "4m")
  })
  default = null
}

variable "disks" {
  type = list(object({
    datastore_id = string
    interface    = string
    size         = number
    discard      = optional(string)
    iothread     = optional(bool)
  }))
  default = []
}

variable "network_devices" {
  type = list(object({
    bridge      = string
    model       = optional(string, "virtio")
    mac_address = optional(string)
    firewall    = optional(bool)
  }))
  default = []
}

variable "hostpci" {
  description = "PCI passthrough devices."
  type = list(object({
    device = string
    id     = string
    pcie   = optional(bool)
    rombar = optional(bool)
  }))
  default = []
}
