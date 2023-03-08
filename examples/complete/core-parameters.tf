# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETERS MAP
# ---------------------------------------------------------------------------------------------------------------------
locals {
  foundation_parameters = {
    management : {
      main_region : "eu-central-1"
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
        core_accounts : {
          org_management : ""
          security : ""
          connectivity : ""
          log_archive : ""
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
}