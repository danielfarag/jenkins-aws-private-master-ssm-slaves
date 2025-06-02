variable "region" {
  type = string
}

variable "ami_type" {
  type = string
  default = "t3.small"
}

variable "private_subnet" {
  type = string
}


variable "slave_sg" {
  type = string
}


variable "iam_profile_name" {
  type = string
}