module "globals" {
  source = "../globals"
}

locals {
  as_string = {
    nonprod = "Non-Production"
    prod    = "Production"
  }

  purpose = {
    nonprod = "non-prd"
    prod    = "prd"
  }
}
