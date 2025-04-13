output "target_capabilities" {
  value = local.target_capabilties
}

output "target_cspa" {
  value = local.target_cspa
}

output "targets" {
  value = var.targets
}

output "targets_output" {
  value = azapi_resource.register_target
}