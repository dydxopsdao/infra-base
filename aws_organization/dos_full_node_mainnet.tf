resource "aws_organizations_account" "dos_full_node_mainnet" {
  provider  = aws.org_level
  name      = "dos-full-node-mainnet"
  email     = "infrastructure+full-node-mainnet@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_full_node_mainnet"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_full_node_mainnet.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_full_node_mainnet" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_full_node_mainnet
  }
}
