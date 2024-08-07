resource "aws_organizations_account" "dos_validator_snapshots" {
  provider  = aws.org_level
  name      = "dos-validator-snapshots"
  email     = "infrastructure+validator-snapshots@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_validator_snapshots"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_validator_snapshots.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_validator_snapshots" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_validator_snapshots
  }
}

# Integrate Terraform Cloud workspace with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_validator_snapshots" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_validator_snapshots
  }

  tfc_workspace_name    = "dos-validator-snapshots"
  tfc_policy_name       = "tfc_validator_snapshots_policy"
  tfc_role_permissions  = ["s3:*", "iam:*"]
  # Apply least-privilege principle when declaring role permissions
}

output "module_outputs_dos_validator_snapshots" {
  value     = module.tfc_oidc_dos_validator_snapshots
}