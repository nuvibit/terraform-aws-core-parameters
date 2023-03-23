# ---------------------------------------------------------------------------------------------------------------------
# ¦ CORE PARAMETERS MAP
# ---------------------------------------------------------------------------------------------------------------------
locals {

  # for this option, the core-parameters module would need to add an additional level to the parameter store mapping

  # Only 3 levels are allowed
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
          org_management : jsonencode({ tag1 : "value", tag2 : "value" })
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


  # convention for level1-name
  # /{capability_domain}.{feature_name}/{attribute_name}
  foundation_parameters_2 = {
    "management.organization" : {
      "main_region" : "eu-central-1"
      "active_regions" : join(",", ["eu-central-1", "eu-central-2"])
      "account_access_role" : "OrganizationAccountAccessRole"
      "core_account_ids" : {
        "org_management" : "123456789000"
        "security" : "123456789000"
        "connectivity" : "123456789000"
        "log_archive" : "123456789000"
        "image_factory" : ""
        "provisioning" : ""
        "common" : ""
      }
      "core_account_tags" : {
        "org_management" : jsonencode({ tag1 : "value", tag2 : "value" })
        "security" : jsonencode({})
        "connectivity" : jsonencode({})
        "log_archive" : jsonencode({})
      }
      "aws_organization" = {
        "aws_service_access_principals" : join(",", [
          "access-analyzer.amazonaws.com",
          "backup.amazonaws.com",
          "cloudtrail.amazonaws.com",
          "compute-optimizer.amazonaws.com",
          "config.amazonaws.com",
          "config-multiaccountsetup.amazonaws.com",
          "ds.amazonaws.com",
          "fms.amazonaws.com",
          "guardduty.amazonaws.com",
          "inspector2.amazonaws.com",
          "malware-protection.guardduty.amazonaws.com",
          "malware-protection.guardduty.amazonaws.com",
          "member.org.stacksets.cloudformation.amazonaws.com",
          "ram.amazonaws.com",
          "reporting.trustedadvisor.amazonaws.com",
          "tagpolicies.tag.amazonaws.com",
          "securityhub.amazonaws.com",
          "servicecatalog.amazonaws.com",
          "ssm.amazonaws.com",
          "sso.amazonaws.com"
        ])
        "enabled_policy_types" : join(",", [
          "AISERVICES_OPT_OUT_POLICY",
          "SERVICE_CONTROL_POLICY",
          "TAG_POLICY"
        ])
      }
    }
    "management.tag_reader" : {
      "iam_role_name" : "read-account-tags-role"
      "iam_role_path" : "/"
      "trustee_arn" = (string)
    }
    "management.org_info_reader" = {
      "iam_role_name" : "foundation-org-info-role"
      "iam_role_path" : "/"
      "trustee_arn" = (string)
    }
    "management.foundation_parameter" : {
      "writer" : {
        "iam_role_name" : "foundation-parameter-writer-role"
        "iam_role_path" : "/"
      }
      "reader" : {
        "iam_role_name" : "foundation-parameter-reader-role"
        "iam_role_path" : "/"
      }
    }
    "management.delegations" : {
      "target_account_id" : {
        "guardduty" : local.core_security_account_id
        "securityhub" : local.core_security_account_id
        "fms" : local.core_security_account_id
        "cloudtrail" : local.core_security_account_id
        "config" : local.core_security_account_id
        "member.org.stacksets.cloudformation" : local.core_security_account_id
      }
    }
    "security.account_hardening" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--account-hardening--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "hub_execution_iam_role_arn" = module.account_hardening.shared_iam_execution_role_arn
    }
    "security.auto_remediation" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--auto-remediation--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "hub_execution_iam_role_arn"                = module.auto_remediation.shared_iam_execution_role_arn
      "revoke_user_access_execution_iam_role_arn" = module.auto_remediation.ar_revoke_user_access.ar_worker_lambda.lambda_execution_role_arn
    }
    "security.aws_config" = {
      "account_baseline" = {
        "recorder_name" : "foundation_aws_config_recorder"
        "delivery_channel_name" : "foundation_aws_config_s3_delivery"
        "iam_role_name" : "foundation-security--aws-config-recorder--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "logging_target_bucket_name" = format("platform-aws-config-aggregator-logs-%s", local.log_archive_account_id)
    }
    "security.custom_config_evaluator" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--auto-remediation--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "shared_execution_iam_role_arn" = module.config_evaluator_euc1.shared_lambda_execution_role_arn
    }
    "security.firewall_manager_service" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--auto-remediation--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "registration_execution_iam_role_arn" = module.firewall_manager_service.waf_logging_lambda.lambda_execution_role_arn
      "central_cw_lg_dest" = {
        "account_id" : local.security_account_id
        "dest_name" = module.firewall_manager_service.waf_logs_aggregator_cloudwatch_logs_destination_name
      }
    }
    "security.iam_roles_anywhere" = {
      "trust_anchor" = {
        "name" : "platform-security--trust-anchor"
        "certificate_bundle" = <<EOT
            -----BEGIN CERTIFICATE-----
            MIIEqDCCA5CgAwIBAgINAe5fGFqz6caEpQQ64TANBgkqhkiG9w0BAQsFADBtMQsw
EOT
      }
    }
    "security.org_cloudtrail" = {
      "cloudtrail_admin" = {
        "cloudwatch_iam_role_name" = var.cloudwatch_logs_iam_role_name
        "cloudwatch_iam_role_path" = var.cloudwatch_logs_iam_role_path
        "cloudwatch_loggroup_name" = var.cloudwatch_loggroup_name
      }
      "cloudtrail_bucket" = {
        "name" = module.core_logging_cloudtrail_mgmt_bucket.name
        "arn"  = module.core_logging_cloudtrail_mgmt_bucket.arn
      }
    }
    "security.qualys_crawler" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--qualys-crawler--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
    }
    "security.member_crawler" = {
      "account_baseline" = {
        "iam_role_name" : "foundation-security--member-crawler--role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "image_consumption_execution_iam_role_arn" = module.report_image_consumption[0].lambda.lambda_execution_role_arn
      "iam_analyzer_execution_iam_role_arn"      = module.report_iam_analyzer.lambda.lambda_execution_role_arn
    }
    "security.image_factory" = {
      "image_tags" = {
        "launch_approval" : local.platform_parameter_readonly["core_image_factory"]["image_tags"]["launch_approval"]
      }
      "ssm_parameterstore_image_product_prefix" : local.platform_parameter_readonly["core_image_factory"]["ssm_parameterstore_image_product_prefix"]
      "allowed_ami_ids" : local.platform_parameter_readonly["core_image_factory"]["allowed_ami_ids"]
      "excepted_ami_accounts" : local.platform_parameter_readonly["core_image_factory"]["excepted_ami_accounts"]
      "account_baseline" = {
        "iam_role_name" : "platform-image-factory-spoke-role"
        "iam_role_path" : "/"
        "iam_role_boundary_policy" : "n/a"
      }
      "launch_permission" = {
        "execution_iam_role_arn" = module.auto_remediation.image_factory_launch_permission.lambda.lambda_execution_role_arn
      }      
    }
    "connectivity.route53" : {
      "public_hosted_zones" : [
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
