variable "aws_region" {
  default = "us-east-1"
}

# variable "generate_ssh_key" {
#   default = true
# }

variable "instance_type" {
  default = "m5.4xlarge"
}

variable "runner_amis" {
  default = {
    us-east-1 = "ami-09d3b3274b6c5d4aa"
  }
}
