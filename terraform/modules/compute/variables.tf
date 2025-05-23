variable "ami_type" {
  type = string
  default = "t3.small"
}

variable "public_ssh_key" {
  type = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "vpc" {
  type = object({
    id = string 
  })
}

variable "public_subnet" {
  type = object({
    id = string 
  })
}


variable "private_subnet" {
  type = object({
    id = string 
  })
}

variable "region" {
  type = string
}

variable "availability_zone" {
  type = string
}