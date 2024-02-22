# infra-base
Infrastructure base for the organization.

## aws-accounts

The `terraform/aws-accounts` directory describes metadata about the organization's member accounts.

In each account there is an IAM user named `terraformer`, meant as a starting point for another
Terraform configuration, defined in another repository.
