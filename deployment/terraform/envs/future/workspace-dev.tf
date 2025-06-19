terraform {
  backend "local" {}
}

resource "terraform_workspace" "dev" {
  name = "dev"
}
