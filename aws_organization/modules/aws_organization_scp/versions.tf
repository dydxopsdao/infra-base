terraform {
  # Specify required providers and their versions
  # Organization-level provider, used to manage the organization is expected to be passed by the caller
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.32.0"
      configuration_aliases = [aws]
    }
  }
  # Specify the minimum required Terraform version
  required_version = ">= 1.0.0"
}