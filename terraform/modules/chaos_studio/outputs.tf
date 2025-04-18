output "target_capabilities" {
  value = local.target_capabilties
}

output "service_targets" {
  value = var.service_targets
}

output "target_output" {
  value = azapi_resource.register_target
}

output "capability_output" {
  value = azapi_resource.register_capability
}