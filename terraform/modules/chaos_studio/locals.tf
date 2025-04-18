locals {
  target_capabilties = flatten(
    [
      for target_name, target_details in var.service_targets : [
      for capability in target_details.capabilities :
      format("%s::%s", target_name, capability)
    ]
    ]
  )
}
