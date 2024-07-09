variable "minimum_password_length" {
  description = "Minimum length of the password"
  type        = number
  default     = 14
}

variable "require_lowercase_characters" {
  description = "Require lowercase characters in the password"
  type        = bool
  default     = true
}

variable "require_numbers" {
  description = "Require numbers in the password"
  type        = bool
  default     = true
}

variable "require_uppercase_characters" {
  description = "Require uppercase characters in the password"
  type        = bool
  default     = true
}

variable "require_symbols" {
  description = "Require symbols in the password"
  type        = bool
  default     = true
}

variable "allow_users_to_change_password" {
  description = "Allow users to change their password"
  type        = bool
  default     = true
}

variable "max_password_age" {
  description = "The maximum age of the password in days"
  type        = number
  default     = 90
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that cannot be reused"
  type        = number
  default     = 6
}
