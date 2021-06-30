terraform {
  backend "remote" {
    organization = "bytebox"

    workspaces {
      prefix = "alhardynet-aws-hub-"
    }
  }
}