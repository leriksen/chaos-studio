run "context_provider" {
  command = apply

  module {
    source = "./modules/context"
  }

  variables {
    resource_group = "chaos-studio"
  }
}

run "akv" {
  command = apply

  module {
    source = "./modules/akv"
  }

  variables {
    rg        = run.context_provider.rg.name
    location  = run.context_provider.rg.location
    tenant_id = run.context_provider.client_config.tenant_id
    pe_subnet = run.context_provider.pe_subnet.id
  }
}

run "test_chaos_studio" {
  command = apply

  module {
    source = "../"
  }

  variables {
    location        = run.context_provider.rg.name
    service_targets = {
      (run.akv.akv.name) = {
        target_id   = run.akv.akv.id
        target_type = "Microsoft-KeyVault"
        capabilities = [
          "DenyAccess-1.0",
          "DisableCertificate-1.0",
          # "IncrementCertificateVersion-1.0",
          "UpdateCertificatePolicy-1.0"
        ]
      }
    }
  }

  assert {
    condition = azapi_resource.register_target["validate-target-akv"].name == "Microsoft-KeyVault"
    error_message = "invalid target output"
  }
}