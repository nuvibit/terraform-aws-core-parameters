# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETERS MAP
# ---------------------------------------------------------------------------------------------------------------------
locals {

  # for this option, the core-parameters module would need to add an additional level to the parameter store mapping
  foundation_parameters_1 = {
    management : {
      main_region : "eu-central-1"
      active_regions : ["eu-central-1", "eu-central-2"]
      read_tags_role_name : "read-account-tags-role"
      account_access_role : "OrganizationAccountAccessRole"
      organization : {
        units : [
          "Suspended",
          "Exceptions",
          "Infrastructure",
          "Security",
          "Workloads/Prod",
          "Workloads/NonProd"
        ]
        core_account_ids : {
          org_management : "123456789000"
          security : "123456789000"
          connectivity : "123456789000"
          log_archive : "123456789000"
        }
        core_account_tags : {
          org_management : jsonencode({tag1: "value", tag2: "value"})
          security : jsonencode({})
          connectivity : jsonencode({})
          log_archive : jsonencode({})
        }
      }
    }
    security : {
      config : {}
      delegation : {
        securityhub : true
        guardduty : false
        config : true
        firewall_manager : true
      }
    }
    connectivity : {
      route53_public_hosted_zones : [
        "example.com"
      ]
    }
  }

  # to avoid additional levels inside the paramter store, the keys itself two keys can be combines
  foundation_parameters_2 = {
    "management.organization" : {
      units : [
          "Suspended",
          "Exceptions",
          "Infrastructure",
          "Security",
          "Workloads/Prod",
          "Workloads/NonProd"
        ]
        core_account_ids : {
          org_management : "123456789000"
          security : "123456789000"
          connectivity : "123456789000"
          log_archive : "123456789000"
        }
        core_account_tags : {
          org_management : jsonencode({tag1: "value", tag2: "value"})
          security : jsonencode({})
          connectivity : jsonencode({})
          log_archive : jsonencode({})
        }
    }
    "management.region" : {
      main_region : "eu-central-1"
      active_regions : ["eu-central-1", "eu-central-2"]
    }
    "management.iam" : {
      read_tags_role_name : "read-account-tags-role"
      account_access_role : "OrganizationAccountAccessRole"
    }
    "security.config" : {}
    "security.delegation" : {
      securityhub : true
      guardduty : false
      config : true
      firewall_manager : true
    }
    "connectivity.route53" : {
      public_hosted_zones : [
        "example.com"
      ]
    }
    "connectivity.ipam" : {
      cidr : [
        "10.0.0.0/8"
      ]
    }
  }
}