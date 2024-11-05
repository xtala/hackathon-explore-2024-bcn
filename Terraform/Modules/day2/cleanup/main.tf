data "vra_machines" "machines_to_cleanup" {
  tags = {
    environment = "env"
    lifecycle   = "test"
  }
}

resource "vra_machine" "cleanup_machines" {
  for_each = data.vra_machines.machines_to_cleanup.machines
  id = each.value.id

  lifecycle {
    prevent_destroy = false
  }
}