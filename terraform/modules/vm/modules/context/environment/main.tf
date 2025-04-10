module "globals" {
  source = "../globals"
}

locals {
  env_sub = {
    dev = "nonprod"
    prd = "prod"
  }
}

module "subscription" {
  source = "../subscription"
  subscription = local.env_sub[var.environment]
}



