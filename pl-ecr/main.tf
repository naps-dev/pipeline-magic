terraform {
  required_version = "= 1.3.4"

  backend "s3" {
    bucket         = "pipeline-magic-state"
    key            = "global/pl-ecr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "pipeline-magic-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "ecr" {
  source               = "cloudposse/ecr/aws"
  version              = "0.34.0"
  namespace            = "test"
  stage                = "test"
  name                 = "naps-dev-containers"
  use_fullname         = false
  image_names          = var.image_names
  scan_images_on_push  = false
  image_tag_mutability = "MUTABLE"
}
