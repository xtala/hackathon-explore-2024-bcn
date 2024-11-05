# Day 0 -> Create Project
module "project" {
  source              = "./modules/day0/project"
  project_name        = var.project_name
  project_description = var.project_description
}


# Day 0 -> Set up Cloud Account
