locals {
  sizes = {
    small = {
      machineCount    = 1
      cpuCount        = 1
      memoryGb        = 2
      image           = "ubuntu22"
      LBport          = 80
      LBProtocol      = "HTTP"
      DenyAccess      = "Deny"
      hasLoadbalancer = false
    }
    medium = {
      machineCount    = 2
      cpuCount        = 2
      memoryGb        = 8
      image           = "ubuntu22"
      LBport          = 80
      LBProtocol      = "HTTP"
      DenyAccess      = "Deny"
      hasLoadbalancer = true
    }
    large = {
      machineCount    = 4
      cpuCount        = 2
      memoryGb        = 16
      image           = "ubuntu22"
      LBport          = 80
      LBProtocol      = "HTTP"
      DenyAccess      = "Deny"
      hasLoadbalancer = true
    }
  }
}

data "vra_blueprint" "Hackathon" {
  name = "Hackathon"
}

data "vra_project" "HOL" {
  name = "HOL Project"
}

resource "vra_deployment" "test" {
  name = "TF_TEST"

  blueprint_id = data.vra_blueprint.Hackathon.id
  project_id   = data.vra_project.HOL.id

  inputs = lookup(local.sizes, var.size, "medium")
}

