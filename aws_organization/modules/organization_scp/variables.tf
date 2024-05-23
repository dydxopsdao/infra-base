variable "scp_name" {
  type        = string
  description = "The name of the Service Control Policy"
}

variable "scp_description" {
  type        = string
  description = "Description of the Service Control Policy"
}

variable "target_ids" {
  type        = list(string)  
  description = "List of target IDs (e.g., account IDs, OU IDs) to attach the SCP to"
}