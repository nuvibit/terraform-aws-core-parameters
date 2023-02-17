
# AWS Core Parameters (via SSM Parameter Store) Terraform module

<!-- LOGO -->
<a href="https://nuvibit.com">
    <img src="https://nuvibit.com/images/logo/logo-nuvibit-badge.png" alt="nuvibit logo" title="nuvibit" align="right" width="100" />
</a>

<!-- SHIELDS -->
[![Maintained by nuvibit.com][nuvibit-shield]][nuvibit-url]
[![Terraform Version][terraform-version-shield]][terraform-version-url]
[![Latest Release][release-shield]][release-url]

<!-- DESCRIPTION -->
[Terraform][terraform-url] module to store and read a terraform HCL map via [AWS][aws-url] SSM Parameter Store.
The main purpose of the module is to store foundation/core parameters from various AWS Accounts and make them available to other AWS Accounts.
Foundation/core parameters can be sourced from different AWS Accounts.
HCL maps with three hierarchy levels are supported.

<!-- ARCHITECTURE -->
## Architecture
![core-parameters architecture][architecture-png]

<!-- REQUIREMENTS -->
## Requirements
| :exclamation: This module utilizes cross-account IAM AssumeRoles      |
|-----------------------------------------|
* A dedicated AWS Account should be hosting the foundation/core parameters in AWS SSM Parameter Store
* Other AWS Accounts can utilize the cross-account IAM AssumeRoles to access foundation/core parameters
* Dedicated Terraform providers are required depending on the intended permissions

<!-- FEATURES -->
## Features
* Parameters in SSM Parameter Store can store HCL maps with up to three hierarchy levels
* Cross-account writer and reader IAM AssumeRoles will be provisioned in the AWS Account hosting the foundation/core parameters
* Parameters can be accessed from other AWS Accounts with IAM AssumeRoles

<!-- USAGE -->
## Usage
### Foundation/Core Parameter Account
```hcl
module "foundation_parameter_roles" {
  source  = "nuvibit/core-parameters/aws//modules/iam-roles"
  version = "~> 1.0"
}

locals {
  foundation_parameters = {
    foundation_parameters = {
      writer_role_arn = module.foundation_parameter_roles.parameters_writer_role_arn
      reader_role_arn = module.foundation_parameter_roles.parameters_reader_role_arn
    }
  }
}

module "foundation_parameter_writer" {
  source  = "nuvibit/core-parameters/aws"
  version = "~> 1.0"

  parameters    = local.foundation_parameters
}
```

### Org Management Account
```hcl
provider "aws" {
  region = "eu-central-1"
  alias  = "foundation_parameter_writer"

  assume_role {
    // requires module.foundation_parameter_reader
    role_arn = local.foundation_parameter_readonly["foundation_parameters"]["writer_role_arn"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

locals {
  foundation_org_mgmt_parameters = {
    version = "1.0"
    org_mgmt = {
      account_id  = data.aws_caller_identity.current.account_id
      org_id      = data.aws_organizations_organization.current.id
      main_region = "eu-central-1"
      example1 = {
        test1_a = "test1_a"
        test1_b = "test1_b"
      }
      example2 = {
        test2_a = "test2_a"
        test2_b = "test2_b"
      }
    }
    core_security = {
      delegation = {
        securityhub      = true
        guardduty        = true
        config           = true
        firewall_manager = true
      }
    }
    account_baseline = {
      auto_remediation = {
        role_name = "foundation-auto-remediation-role"
      }
      aws_config = {
        role_name = "FoundationAwsConfigRole"
      }
    }
  }
}

module "foundation_parameter_writer" {
  source  = "nuvibit/core-parameters/aws"
  version = "~> 1.0"

  parameters = local.foundation_org_mgmt_parameters
  providers = {
    aws.ssm_ps_writer = aws.foundation_org_mgmt_parameters
  }
}
```
Core Security delegation settings will be specified and configured in the Org Mgmt account.

### Core Security Account
```hcl
provider "aws" {
  region = "eu-central-1"
  alias  = "foundation_parameter_writer"

  assume_role {
    // requires module.foundation_parameter_reader
    role_arn = local.foundation_parameter_readonly["foundation_parameters"]["writer_role_arn"]
  }
}

data "aws_caller_identity" "current" {}

locals {
  foundation_core_security_parameters = {
    core_security = {
      account_id = data.aws_caller_identity.current.account_id
      auto_remediation = {
        execution_role_arn = module.core_security.auto_remediation["execution_role_arn"]
      }
      aws_config = {
        aggregator_name = module.core_security.aws_config["aggregator_name"]
      }
    }
  }
}

module "foundation_parameter_writer" {
  source  = "nuvibit/core-parameters/aws"
  version = "~> 1.0"

  parameters = local.foundation_core_security_parameters
  providers = {
    aws.ssm_ps_writer = aws.foundation_parameter_writer
  }
}
```

### Other AWS Accounts
```hcl
provider "aws" {
  region = "eu-central-1"
  alias  = "foundation_parameter_reader"

  assume_role {
    role_arn = "arn:aws:iam::{account-id of Foundation Core Parameter Account}:role/core-parameter-reader-role"
  }
}

module "foundation_parameter_reader" {
  source  = "nuvibit/core-parameters/aws//modules/reader"
  version = "~> 1.0"

  providers = {
    aws.ssm_ps_reader = aws.foundation_parameter_reader
  }
}

locals {
  foundation_parameter_readonly = module.foundation_parameter_reader.parameters
}

output "foundation_parameters" {
  value = local.foundation_parameter_readonly
}
```

### Example output of foundation/core parameters
```hcl
{
  "account_baseline" = {
    "auto_remediation" = {
      "role_name" = "foundation-auto-remediation-role"
    }
    "aws_config" = {
      "role_name" = "FoundationAwsConfigRole"
    }
  }
  "core_security" = {
    "account_id" = "******"
    "auto_remediation" = {
      "execution_role_arn" = "arn:aws:iam::******:role/auto-remediation-execution-role"
    }
    "aws_config" = {
      "aggregator_name" = "foundation_config_aggregator"
    }
    "delegation" = {
      "config"           = "true"
      "firewall_manager" = "true"
      "guardduty"        = "true"
      "securityhub"      = "true"
    }
  }
  "org_mgmt" = {
    "account_id" = "******"
    "example1" = {
      test1_a = "test1_a"
      test1_b = "test1_b"
    }
    "example2" = {
      "test2_a" = "test2_a"
      "test2_b" = "test2_b"
    }
    "main_region" = "eu-central-1"
    "org_id"      = "o-******"
  }
}
```

<!-- EXAMPLES -->
## Examples

* [`examples/complete`][core-parameters-test-url]

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.ssm_ps_writer"></a> [aws.ssm\_ps\_writer](#provider\_aws.ssm\_ps\_writer) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ssm_parameter.ssm_parameters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A map of parameters which should be stored as a map in SSM Parameter Store. | `any` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | KMS Key to be used to encrypt the parameter entries. | `string` | `null` | no |
| <a name="input_parameters_overwrite"></a> [parameters\_overwrite](#input\_parameters\_overwrite) | Set to true to allow overwriting existing parameters. IAM role with write access is required. | `bool` | `false` | no |
| <a name="input_parameters_path_prefix"></a> [parameters\_path\_prefix](#input\_parameters\_path\_prefix) | Prefix name to allow fully qualified parameter names which allows parameters to be stored as a map. | `string` | `"/foundation"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | A map of tags to assign to the resources in this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_parameters_map"></a> [parameters\_map](#output\_parameters\_map) | The map of parameters which are stored as a map in SSM Parameter Store. |
| <a name="output_parameters_path_prefix"></a> [parameters\_path\_prefix](#output\_parameters\_path\_prefix) | Pass through parameters\_path\_prefix. |
<!-- END_TF_DOCS -->

<!-- AUTHORS -->
## Authors

This module is maintained by [Nuvibit][nuvibit-url] with help from [these amazing contributors][contributors-url]

<!-- LICENSE -->
## License

This module is licensed under Apache 2.0
<br />
See [LICENSE][license-url] for full details

<!-- COPYRIGHT -->
<br />
<br />
<p align="center">Copyright &copy; 2022 Nuvibit AG</p>

<!-- MARKDOWN LINKS & IMAGES -->
[nuvibit-shield]: https://img.shields.io/badge/maintained%20by-nuvibit.com-%235849a6.svg?style=flat&color=1c83ba
[nuvibit-url]: https://nuvibit.com
[terraform-version-shield]: https://img.shields.io/badge/terraform-%3E%3D1.0.0-blue.svg?style=flat&color=blueviolet
[terraform-version-url]: https://www.terraform.io/upgrade-guides/1-0.html
[release-shield]: https://img.shields.io/github/v/release/nuvibit/terraform-aws-core-parameters?style=flat&color=success
[architecture-png]: https://github.com/nuvibit/terraform-aws-core-parameters/blob/main/docs/architecture.png?raw=true
[release-url]: https://github.com/nuvibit/terraform-aws-core-parameters/releases
[contributors-url]: https://github.com/nuvibit/terraform-aws-core-parameters/graphs/contributors
[license-url]: https://github.com/nuvibit/terraform-aws-core-parameters/tree/main/LICENSE
[terraform-url]: https://www.terraform.io
[aws-url]: https://aws.amazon.com
[core-parameters-test-url]: https://github.com/nuvibit/terraform-aws-core-parameters/tree/main/examples/complete