provider "aws" {
  region = var.aws_region_this
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id_this}:role/${var.aws_assume_role}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias      = "stage"
  region     = "ap-southeast-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id_stage}:role/${var.aws_assume_role}"
    session_name = "terraform"
  }
}

provider "aws" {
  alias      = "prod"
  region     = "ap-southeast-2"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id_prod}:role/${var.aws_assume_role}"
    session_name = "terraform"
  }
}