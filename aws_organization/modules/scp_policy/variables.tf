variable "policy_name" {
  description = "The name of the SCP policy"
  type        = string
}

variable "policy_description" {
  description = "The description of the SCP policy"
  type        = string
}

variable "approved_regions" {
  description = "List of approved regions"
  type        = list(string)
}

variable "target_ou_id" {
  description = "The ID of the Organizational Unit (OU) to attach the SCP policy"
  type        = string
}