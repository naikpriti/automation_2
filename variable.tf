variable "automation_account_name" {
  type        = string
  description = "name of automation account"

}

variable "location" {
  type        = string
  description = "Azure region where the resources would be provisioned"
}

variable "resource_group_name" {
  type        = string
  description = "resource group name "

}

variable "subscription_id" {
  type        = string
  description = "subscription id"

}

variable "runbook_name" {
  type        = string
  description = "subscription id"

}


variable "clustername" {
  type        = string
  description = "name of cluster"

}

variable "timezone" {
  type        = string
  description = "name of timezone"

}

variable "start_schedule_time" {
  type        = string
  description = "schedule start time"

}

variable "start_schedule_name" {
  type        = string
  description = "schedule start time"

}

variable "stop_schedule_time" {
  type        = string
  description = "schedule start time"

}

variable "stop_schedule_name" {
  type        = string
  description = "schedule start time"

}

/*variable "start_week_day"{
    type = string
    description = "schedule start time"

}

variable "stop_week_day"{
    type = string
    description = "schedule start time"

}*/