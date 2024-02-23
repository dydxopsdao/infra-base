terraform {
  # cloud {
  #   organization = "dydxopsdao"
  #   workspaces {
  #     name = "aws-organization"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.32.0"
    }
  }
}

# Organization-level provider, used to manage member accounts
# Use an explicit alias to prevent passing this to member account modules (the default behavior)
provider "aws" {
  alias   = "org_level"
  region  = "ap-northeast-1"
  profile = "dydxopsdao"
}
