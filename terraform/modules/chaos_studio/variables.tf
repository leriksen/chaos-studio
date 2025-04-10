variable "location" {
  type = string
}

variable "targets" {
  type = map(
    object(
      {
        target_type  = string
        capabilities = optional(list(string), [])
      }
    )
  )
}

#
# variable "target_id" {
#   type = string
# }
# variable "target_type" {
#   type = string
# }
