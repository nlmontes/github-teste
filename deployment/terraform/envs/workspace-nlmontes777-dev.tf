terraform {
  backend "local" {}
}

resource "terraform_workspace" "nlmontes777-dev" {
  name = "nlmontes777-dev"
}
