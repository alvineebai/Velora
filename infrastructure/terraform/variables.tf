variable "subscription_id" {
  description = "Azure subscription where Velora infrastructure will be deployed"
  type        = string
}

variable "location" {
  description = "Azure region where Velora infrastructure will be deployed"
  type        = string
  default     = "centralus"
}

variable "postgresql_admin_password" {
  description = "Administrator password for Velora PostgreSQL"
  type        = string
  sensitive   = true
}

variable "github_actions_principal_id" {
  description = "Object ID of the Velora GitHub Actions service principal"
  type        = string
}

variable "tenant_id" {
  description = "Azure Active Directory tenant ID"
  type        = string
}