resource "vra_blueprint" "blueprint" {
  name       = var.blueprint_name
  project_id = var.project_id
  content    = var.blueprint_content
}