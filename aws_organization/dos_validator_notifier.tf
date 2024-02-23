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
  alias   = "dos_validator_notifier"
  region  = "ap-northeast-1"
  profile = "dydxopsdao"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_validator_notifier.id}:role/OrganizationAccountAccessRole"
  }
}

module "dos_validator_notifier_terraformer" {
  source = "./modules/iam_user"
  providers = {
    aws = aws.dos_validator_notifier
  }
  name = "terraformer"
  permissions = [
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

output "dos_validator_notifier_terraformer_outputs" {
  value     = module.dos_validator_notifier_terraformer
  sensitive = true
}
