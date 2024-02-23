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
# Use an explicit alias to prevent passing this to member account modules (the default behavior)
provider "aws" {
  alias  = "org_level"
  region = "ap-northeast-1"
}
