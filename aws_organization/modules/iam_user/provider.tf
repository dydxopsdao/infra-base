# A non-default, member account-specific provider is expected to be passed by the caller.
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "= 5.32.0"
      configuration_aliases = [aws]
    }
  }
}
