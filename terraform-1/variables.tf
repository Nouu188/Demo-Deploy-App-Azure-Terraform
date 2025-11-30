variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "rg_name" {
    description = "Resource group name"
    type        = string 
}

variable "app_name" {
    description = "App name"
    type        = string 
}

variable "postgres_server_name" {
    description = "PostgreSQL Flexible Server name"
    type        = string 
}

variable "postgres_admin_login" {
    description = "PostgreSQL administrator login"
    type        = string 
}

variable "postgres_admin_password" {
    description = "PostgreSQL administrator password"
    type        = string
    sensitive   = true
}

variable "postgres_database_name" {
    description = "PostgreSQL database name"
    type        = string 
}