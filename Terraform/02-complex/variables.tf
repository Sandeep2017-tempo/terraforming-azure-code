variable "location" {
  description = "Azure datacenter to deploy to."
  default     = "West Europe"
}

variable "env" {
  description = "A short name of the environment. E.g. test, prod, qa"
}

variable "servicebus_name" {
  description = "A globally unique Azure service bus name"
}
