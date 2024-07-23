resource "aws_organizations_account" "dos_validator_notifier" {
  provider  = aws.org_level
  name      = "dos-validator-notifier"
  email     = "infrastructure+validator+notifier@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_validator_notifier"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_validator_notifier.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_validator_notifier" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_validator_notifier
  }
}

# Integrate Terraform Cloud with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_validator_notifier" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_validator_notifier
  }

  tfc_workspace_name    = "signotifier"
  tfc_policy_name       = "tfc_signotifier_policy"
  tfc_role_permissions = [
    # KMS full access
    "kms:*",

    # IAM full access
    "iam:*",
    "organizations:DescribeAccount",
    "organizations:DescribeOrganization",
    "organizations:DescribeOrganizationalUnit",
    "organizations:DescribePolicy",
    "organizations:ListChildren",
    "organizations:ListParents",
    "organizations:ListPoliciesForTarget",
    "organizations:ListRoots",
    "organizations:ListPolicies",
    "organizations:ListTargetsForPolicy",

    # Lambda full access
    "cloudformation:DescribeStacks",
    "cloudformation:ListStackResources",
    "cloudwatch:ListMetrics",
    "cloudwatch:GetMetricData",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeSubnets",
    "ec2:DescribeVpcs",
    "kms:ListAliases",
    "iam:GetPolicy",
    "iam:GetPolicyVersion",
    "iam:GetRole",
    "iam:GetRolePolicy",
    "iam:ListAttachedRolePolicies",
    "iam:ListRolePolicies",
    "iam:ListRoles",
    "lambda:*",
    "logs:DescribeLogGroups",
    "states:DescribeStateMachine",
    "states:ListStateMachines",
    "tag:GetResources",
    "xray:GetTraceSummaries",
    "xray:BatchGetTraces",

    # CodeBuild full access
    "codebuild:*",
    "codecommit:GetBranch",
    "codecommit:GetCommit",
    "codecommit:GetRepository",
    "codecommit:ListBranches",
    "codecommit:ListRepositories",
    "cloudwatch:GetMetricStatistics",
    "ec2:DescribeVpcs",
    "ec2:DescribeSecurityGroups",
    "ec2:DescribeSubnets",
    "ecr:DescribeRepositories",
    "ecr:ListImages",
    "elasticfilesystem:DescribeFileSystems",
    "events:DeleteRule",
    "events:DescribeRule",
    "events:DisableRule",
    "events:EnableRule",
    "events:ListTargetsByRule",
    "events:ListRuleNamesByTarget",
    "events:PutRule",
    "events:PutTargets",
    "events:RemoveTargets",
    "logs:GetLogEvents",
    "s3:GetBucketLocation",
    "s3:ListAllMyBuckets",

    # EC2 Container Registry (ECR) full access
    "ecr:*",
    "cloudtrail:LookupEvents",
    "iam:CreateServiceLinkedRole",
  ]
}

output "module_outputs_dos_validator_notifier" {
  value     = module.tfc_oidc_dos_validator_notifier
}