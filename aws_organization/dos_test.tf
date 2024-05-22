# AWS account ID: 767397888215

resource "aws_organizations_account" "dos_test" {
  provider  = aws.org_level
  name      = "dos-test"
  email     = "test@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias   = "dos_test"
  region  = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_test.id}:role/OrganizationAccountAccessRole"
  }
}

module "dos_test_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_test
  }
  name        = "terraformer"
  permissions = [
    "ec2:*"
  ]
}

output "dos_test_terraformer_outputs" {
  value     = module.dos_test_terraformer
  sensitive = true
}