resource "aws_organizations_account" "dos_amplitude_api_gateway" {
  provider  = aws.org_level
  name      = "dos-amplitude-api-gateway"
  email     = "infrastructure+amplitude-api-gateway@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias   = "dos_amplitude_api_gateway"
  region  = "ap-northeast-1"
  profile = "dydxopsdao"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_amplitude_api_gateway.id}:role/OrganizationAccountAccessRole"
  }
}

module "dos_amplitude_api_gateway_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_amplitude_api_gateway
  }
  name        = "terraformer"
  permissions = ["apigateway:*"]
}

output "dos_amplitude_api_gateway_terraformer_outputs" {
  value     = module.dos_amplitude_api_gateway_terraformer
  sensitive = true
}
