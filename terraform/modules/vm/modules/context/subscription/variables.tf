variable "subscription" {
  type        = string
  description = "description"
  validation {
    condition     = contains(["nonprod", "prod"], var.subscription)
    error_message = "The subscription must be one of [nonprod, prod]"
  }
}
