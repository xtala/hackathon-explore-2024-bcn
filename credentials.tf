locals {
  bearer = jsondecode(terracurl_request.token.response)
}
resource "terracurl_request" "token" {
  name            = "get-token"
  url             = "${var.vra_host}/csp/gateway/am/api/login?access_token"
  method          = "POST"
  skip_tls_verify = true
  response_codes = [
    200,
    201,
    400,
    500
  ]
  headers = {
    Accept       = "application/json"
    Content-Type = "application/json"
  }
  request_body = <<EOF
{
  "username" : "${var.vra_username}",
    "password" : "${var.vra_password}"
    }
EOF
}