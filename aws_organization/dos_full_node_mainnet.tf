# AWS account ID: 637423447856

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
  alias   = "dos_full_node_mainnet"
  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::637423447856:role/OrganizationAccountAccessRole"
  }
}

module "dos_full_node_mainnet_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_full_node_mainnet
  }
  name        = "terraformer"
  permissions = ["ec2:*"]
}

output "dos_full_node_mainnet_terraformer_outputs" {
  value     = module.dos_full_node_mainnet_terraformer
  sensitive = true
}
