provider "aws" {
  region = "us-west-2" // region to create resource
}

# initialazing remote state
terraform {
  backend "s3" {
    bucket = "terraform-nastya-test-bucket" // where to SAVE Terraform State
    key    = "prod/terraform.tfstate"       // object name in the bucket to SAVE Terraform State
    region = "us-east-1"                    // Region where bucket is created
  }
}
