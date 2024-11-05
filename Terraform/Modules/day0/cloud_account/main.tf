resource "vra_cloud_account_aws" "aws_account" {
  name      = var.cloud_account_name
  access_key = var.access_key
  secret_key = var.secret_key
  region_ids = var.region_ids
  create_default_zone = true
}