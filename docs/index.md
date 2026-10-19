# iac-proxmox-vm

One `proxmox_virtual_environment_vm` guarded with `prevent_destroy`, with `on_boot` and
`reboot_after_update` as inputs so a plan can be made unable to reboot the VM.

## Adopting an existing VM

1. Read the live config (`GET /nodes/<node>/qemu/<vmid>/config`) and write the inputs from it.
2. Import: `proxmox_virtual_environment_vm.this` with id `<node>/<vm_id>`.
3. The first plan must show no change. Any diff is a stop: fix the inputs to match reality, never
   the other way round.

Provider defaults that differ from the live VM (`on_boot`, `reboot_after_update`, ...) are inputs
so they can be pinned.

## Token permissions

The bpg provider calls the API even for provider-only attribute changes, so a token without write
permissions makes such a change fail with 403. Avoid pins that differ from the provider default
when the token is read-mostly.

## Not covered

Snapshots, orphan disks (`unusedN`) and cloud-init. Add inputs when a consumer needs them.
