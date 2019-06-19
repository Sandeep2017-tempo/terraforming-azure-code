variable "location" {
  description = "Azure datacenter to deploy to."
  default     = "West Europe"
}

variable "env" {
  description = "A short name of the environment. E.g. test, prod, qa"
}

variable "tenantId" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
}

variable "kvDefaultUserObjectId" {
  description = "Object ID of the AD user to get read access by default"
}
