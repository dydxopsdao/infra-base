variable "allowed_global_actions" {
  type        = list(string)
  description = "List of allowed global actions for the region restriction SCP"
}

variable "approved_regions" {
  type        = list(string)
  description = "List of approved AWS regions"
}


# Other variables related to AWS organization management can be added here