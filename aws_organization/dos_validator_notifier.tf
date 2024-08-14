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

# Grant an external AWS Account permission to access the Lambda function by assuming a role.

# Define an IAM role that the external AWS account will assume
resource "aws_iam_role" "lambda_invoke_role" {
  provider = aws.dos_validator_notifier
  name = "ExternalSignotifierInvoker"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Define the policy document for assuming the role
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["332066407361"]
    }
  }
}

# Define the policy document that allows invoking the Lambda function URL
data "aws_iam_policy_document" "lambda_invoke_policy" {
  statement {
    effect    = "Allow"
    actions   = ["lambda:InvokeFunctionUrl"]
    resources = ["arn:aws:lambda:ap-northeast-1:791066989954:function:signotifier"]
  }
}

# Attach a policy to the role that allows invoking the Lambda function URL
resource "aws_iam_role_policy" "lambda_invoke_policy" {
  provider = aws.dos_validator_notifier
  name   = "signotifier_invoke_policy"
  role   = aws_iam_role.lambda_invoke_role.id

  policy = data.aws_iam_policy_document.lambda_invoke_policy.json
}