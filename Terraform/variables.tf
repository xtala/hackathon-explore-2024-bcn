variable "size" {
  type = string

  validation {
    condition     = contains(["small", "medium", "large"], var.size)
    error_message = "Size should be one of: small, medium or large."
  }
}

variable "vra_host" {
  type    = string
  default = "https://aria-auto.corp.vmbeans.com"
}
variable "vra_username" {
  type    = string
  default = "admin"
}
variable "vra_password" {
  type    = string
  default = "VMware1!"
}
