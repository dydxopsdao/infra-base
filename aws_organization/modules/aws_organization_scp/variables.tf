variable "policy_name" {
  description = "The name of the SCP policy"
  type        = string
}

variable "policy_description" {
  description = "The description of the SCP policy"
  type        = string
}

# Define the structure for policy statements, including optional conditions
variable "policy_statements" {
  description = "List of policy statements for the SCP"
  type = list(object({
    effect      = string
    actions     = optional(list(string))
    not_actions = optional(list(string))
    resources   = list(string)
    conditions  = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
}

variable "target_ids" {
  description = "List of target IDs (e.g., account IDs, OU IDs) to attach the SCP to"
  type        = list(string)
}