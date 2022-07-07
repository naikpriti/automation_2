terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = "32496c5b-1147-452c-8469-3a11028f8946"
  #client_id       = "6fea9247-494c-46bf-9ef9-06e22218a4a3"
  #client_secret   = "Lzq8Q~DNXgu37MIj1fC-tDxWYKyGz16ymTJTEasf"
  tenant_id = "bc877e61-f6cf-4461-accd-0565fa4ca357"
}

data "azurerm_subscription" "primary" {}

resource "azurerm_automation_account" "example" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"


  identity {
    type = "SystemAssigned"
  }

}

/*data "azurerm_role_definition" "contributor" {
  name = "Owner"
}*/

/*resource "azurerm_role_definition" "role_assignment_contributor" {
     name  = "Azure Kubernetes Service cluster Admin Role"
     scope = data.azurerm_subscription.primary.id
     description = "A role designed for writing and deleting role assignments"
    
     permissions {
         actions = [
             "Microsoft.Authorization/roleAssignments/write",
             "Microsoft.Authorization/roleAssignments/delete",
         ]
         not_actions = []
     }
    
     assignable_scopes = [
         data.azurerm_subscription.primary.id
     ]
 }
 */

/*resource "azurerm_role_assignment" "example" {
  scope              = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id       = azurerm_automation_account.example.identity[0].principal_id
  
}*/

/*resource "azurerm_role_assignment" "test" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.example.identity[0].principal_id
}*/



# provisioner "local-exec" {
#      command = <<-EOT
#      az role assignment create --assignee-object-id azurerm_automation_account.example.principal_id
#      --scope "/subscriptions/149fdc07-203b-4014-9552-2dab6195289b"
#   EOT
#  }
#}


/*output "variable_id" {
  value = azurerm_automation_account.example
}*/



data "local_file" "example" {
  filename = "./example.ps"
}

resource "azurerm_automation_runbook" "example" {
  name                    = var.runbook_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is an example runbook"
  runbook_type            = "PowerShell"

  content = data.local_file.example.content
}



resource "azurerm_automation_schedule" "start" {
  name                    = var.start_schedule_name
  resource_group_name     = var.location
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "Week"
  interval                = 1
  timezone                = var.timezone
  start_time              = var.start_schedule_time
  description             = "This is an example schedule"
  week_days               = ["Monday"]

}

resource "azurerm_automation_schedule" "stop" {
  name                    = var.stop_schedule_name
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  frequency               = "Week"
  interval                = 1
  timezone                = var.timezone
  start_time              = var.stop_schedule_time
  description             = "This is an example schedule"
  week_days               = ["Friday"]

}

resource "azurerm_automation_job_schedule" "demo_start" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  schedule_name           = azurerm_automation_schedule.start.name
  runbook_name            = azurerm_automation_runbook.example.name

  parameters = {
    aksclustername    = "${var.clustername}"
    resourcegroupname = "${var.resource_group_name}"
    operation         = "start"

  }


}

resource "azurerm_automation_job_schedule" "demo_stop" {
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.example.name
  schedule_name           = azurerm_automation_schedule.stop.name
  runbook_name            = azurerm_automation_runbook.example.name

  parameters = {
    aksclustername    = "${var.clustername}"
    resourcegroupname = "${var.resource_group_name}"
    operation         = "stop"

  }

}

