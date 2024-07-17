
variable "tfc_hostname" {
  type        = string
  description = "The hostname of the TFC/TFE instance you're using (also used as the OIDC provider URL)"
  default     = "app.terraform.io"
}

variable "tfc_aws_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
  default     = "dydxopsdao"

}

variable "tfc_project_name" {
  type        = string
  description = "The name of your Terraform Cloud project"
  default     = "DOS"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of your Terraform Cloud workspace"
  default     = ""
}

variable "tfc_role_name" {
  type        = string
  description = "The name of the IAM role for Terraform Cloud workspace"
  default     = "tfc_workspace_role"
}

variable "tfc_policy_name" {
  type        = string
  description = "The name of the IAM policy for Terraform Cloud workspace"
  default     = "tfc_workspace_policy"
}

variable "tfc_role_permissions" {
  type        = list(string)
  description = "List of IAM permissions to grant to the Terraform Cloud workspace role"
  default     = []
}