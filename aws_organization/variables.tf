variable "prevent_leave_org_target_ids" {
  type        = list(string)
  description = "Target IDs for the prevent leave organization SCP"
}

variable "allowed_global_actions" {
  type        = list(string)
  description = "List of allowed global actions for the region restriction SCP"
}

variable "approved_regions" {
  type        = list(string)
  description = "List of approved AWS regions"
}

variable "region_restriction_target_ids" {
  type        = list(string)
  description = "Target IDs for the region restriction SCP"
}

# Other variables related to AWS organization management can be added here