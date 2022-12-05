variable "aws_region" {
  default = "us-east-1"
}

# variable "generate_ssh_key" {
#   default = true
# }

variable "instance_type" {
  default = "m5.large"
}

variable "runner_amis" {
  default = {
    # Fedora-Cloud-Base-37-1.7.x86_64-hvm-us-east-1-gp2-0
    # Official AMI per https://alt.fedoraproject.org/cloud/
    us-east-1 = "ami-023fb534213ca41da"
  }
}
