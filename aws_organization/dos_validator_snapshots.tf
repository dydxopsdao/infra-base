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

module "dos_validator_snapshots_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_validator_snapshots
  }
  name        = "terraformer"
  permissions = ["s3:*", "iam:*"]
}

output "dos_validator_snapshots_organization_id" {
  value = aws_organizations_account.dos_validator_snapshots.id
}

output "dos_validator_snapshots_terraformer_outputs" {
  value     = module.dos_validator_snapshots_terraformer
  sensitive = true
}
