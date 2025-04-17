variable "location" {
  type = string
}

variable "targets" {
  type = map(
    object(
      {
        target_type  = string
        target_id    = string
        capabilities = optional(list(string), [])
        cspa         = optional(
          object(
            {
              name    = string
              subnets = object(
                {
                  containerSubnetId = string
                  relaySubnetId     = string
                }
              )
            }
          ), null
        )
      }
    )
  )
}
