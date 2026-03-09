terraform {
    backend "s3" {
      bucket = "pgagi-terraform-state"
      key = "two-tier/dev/terraform.tfstate"
      use_lockfile = true
      region = "ap-south-1"
      encrypt = true
    }
}