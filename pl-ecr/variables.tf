variable "remote_region" {
  default = "us-east-1"
}

variable "remote_bucket" {
  default = "pipeline-magic-state"
}

variable "remote_key" {
  default = "global/pl-ecr/terraform.tfstate"
}

variable "remote_table" {
  default = "pipeline-magic-locks"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "image_names" {
  type    = list(string)
  default = ["mixmode", "sitestore", "mixmode-sensor"]
}
