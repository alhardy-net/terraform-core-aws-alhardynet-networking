terraform {
  backend "remote" {
    organization = "bytebox"

    workspaces {
      prefix = "core-aws-alhardynet-networking-hub-peering-"
    }
  }
}