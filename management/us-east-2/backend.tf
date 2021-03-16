terraform {
  backend "remote" {
    organization = "demo-vpc"

    workspaces {
      name = "management-us-east-2"
    }
  }
}
