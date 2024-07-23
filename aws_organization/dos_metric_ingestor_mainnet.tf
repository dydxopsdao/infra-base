resource "aws_organizations_account" "dos_metric_ingestor_mainnet" {
  provider  = aws.org_level
  name      = "dos-metric-ingestor-mainnet"
  email     = "infrastructure+metric-ingestor-mainnet@dydxopsservices.com"
  role_name = "OrganizationAccountAccessRole"

  # There is no AWS Organizations API for reading role_name
  lifecycle {
    ignore_changes = [role_name]
  }
}

# Account-level provider, used to manage resources in the member account
provider "aws" {
  alias  = "dos_metric_ingestor_mainnet"
  region = "ap-northeast-1"
  assume_role {
    role_arn = "arn:aws:iam::${aws_organizations_account.dos_metric_ingestor_mainnet.id}:role/OrganizationAccountAccessRole"
  }
}

# Define the IAM account password policy
module "password_policy_dos_metric_ingestor_mainnet" {
  source = "./modules/password_policy"
  providers = {
    aws = aws.dos_metric_ingestor_mainnet
  }
}

# IAM role to enable permission for ssm on EC2
resource "aws_iam_role" "ssm_role" {
  name = "EC2SSMRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "EC2SSMInstanceProfile"
  role = aws_iam_role.ssm_role.name
}

# Integrate Terraform Cloud workspace with AWS using OpenID Connect (OIDC)
module "tfc_oidc_dos_metric_ingestor_mainnet" {
  source = "./modules/tfc_oidc"
  providers = {
    aws = aws.dos_metric_ingestor_mainnet
  }

  tfc_workspace_name    = "v4-metric-ingestor-mainnet"
  tfc_policy_name       = "tfc_metric_ingestor_mainnet_policy"
  tfc_role_permissions = [
    # IAM full access
    "iam:*",

    # EC2 full access
    "ec2:*",
    "ecs:*",
    "elasticloadbalancing:*",
    "cloudwatch:*",
    "autoscaling:*",
    "application-autoscaling:*",
    "codedeploy:*",
    "appmesh:DescribeVirtualGateway",
    "appmesh:DescribeVirtualNode",
    "appmesh:ListMeshes",
    "appmesh:ListVirtualGateways",
    "appmesh:ListVirtualNodes",
    "cloudformation:CreateStack",
    "cloudformation:DeleteStack",
    "cloudformation:DescribeStack*",
    "cloudformation:UpdateStack",
    "cloudwatch:DeleteAlarms",
    "cloudwatch:DescribeAlarms",
    "cloudwatch:GetMetricStatistics",
    "cloudwatch:PutMetricAlarm",
    "elasticfilesystem:DescribeAccessPoints",
    "elasticfilesystem:DescribeFileSystems",
    "events:DeleteRule",
    "events:DescribeRule",
    "events:ListRuleNamesByTarget",
    "events:ListTargetsByRule",
    "events:PutRule",
    "events:PutTargets",
    "events:RemoveTargets",
    "fsx:DescribeFileSystems",
    "lambda:ListFunctions",
    "logs:CreateLogGroup",
    "logs:DescribeLogGroups",
    "logs:FilterLogEvents",
    "route53:CreateHostedZone",
    "route53:DeleteHostedZone",
    "route53:GetHealthCheck",
    "route53:GetHostedZone",
    "route53:ListHostedZonesByName",
    "servicediscovery:CreatePrivateDnsNamespace",
    "servicediscovery:CreateService",
    "servicediscovery:DeleteService",
    "servicediscovery:GetNamespace",
    "servicediscovery:GetOperation",
    "servicediscovery:GetService",
    "servicediscovery:ListNamespaces",
    "servicediscovery:ListServices",
    "servicediscovery:UpdateService",
    "sns:ListTopics",
  ]
  # Apply least-privilege principle when declaring role permissions
}

output "module_outputs_dos_metric_ingestor_mainnet" {
  value     = module.tfc_oidc_dos_metric_ingestor_mainnet
}