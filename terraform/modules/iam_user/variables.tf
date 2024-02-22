variable "name" {
  type        = string
  description = "IAM user name."
}

variable "permissions" {
  type        = list(string)
  description = "List of permissions for the 'terraformer' IAM user."
}
