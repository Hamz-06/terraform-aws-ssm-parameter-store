
variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "application_name" {
  description = "The name of the application being deployed."
  type        = string

  validation {
    condition     = length(var.application_name) >= 2 && length(var.application_name) <= 30
    error_message = "Project name must be between 2 and 30 characters long."
  }
}

//potentially add a different path for lambda
variable "ssm_parameters" {
  description = "Map of SSM parameter keys to their configuration."
  type = map(object({
    value     = string
    overwrite = bool
    version   = number
  }))
  sensitive = true
  default   = {}
}

variable "tags" {
  description = "Tags to apply to all SSM parameters."
  type        = map(string)
  default     = {}
}
