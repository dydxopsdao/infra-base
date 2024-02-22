# Provide the following credentials of the organization-level user in the environment:
#  export AWS_ACCESS_KEY_ID=...
#  export AWS_SECRET_ACCESS_KEY=...

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.32.0"
    }
  }
}

# Organization-level provider, used to manage member accounts
provider "aws" {
  alias  = "org_level"
  region = "ap-northeast-1"
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "account_level"
  region = "ap-northeast-1"

  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"
  }
}
