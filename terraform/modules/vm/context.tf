module "globals" {
  source = "modules/context/globals"
}

module "subscription" {
  source       = "modules/context/subscription"
  subscription = "prod"
}

module "environment" {
  source      = "modules/context/environment"
  environment = "prd"
}