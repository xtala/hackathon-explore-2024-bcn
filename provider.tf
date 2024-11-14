terraform {
  cloud { 
    organization = "Amcom-org" 
    workspaces { 
      name = "hackathon-explore-2024-bcn" 
  } 
  required_providers {
    vra = {
      source  = "vmware/vra"
      version = "0.9.0"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "1.2.1"
    }
  }
}

provider "vra" {
  url           = var.vra_host
  refresh_token = "xxxxxxxxxxxxxxxxxxxxxx"
}

provider "terracurl" {}
