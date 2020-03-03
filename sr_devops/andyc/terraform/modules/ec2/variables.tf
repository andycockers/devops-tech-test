variable "region" {
  description = "The AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "keyname" {
  description = "The key pair to associate with the instance"
  type        = string
  default     = "andyc"
}

variable "keypair" {
  description = "A public key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBD6G9EmUR7HTM7CRRamPOr9IQxw2pyuiUpKLXkxTliRMynUhOHm4mh89mfiBJjQv2gSUpfPodkUxLvTI+T0lygrfV8OHO7FHR4GGeZrGlH7XrRgaNDgjnsbUVjsptqNI6zdmJvHYn+Qot/t80qGCTf0BseNdg7gnxpk8IdZdxUEluPU0CjqEVkFOYsKr3NxiYCo7DTU2PWJJg6sCV85/ANjNO48hIFg5+5eoXEMu3/lpuID93TortwPJtqUn0k3RL7mjEDvhwMJXj9dhcUVWpG9SOydiygFxcUrwKeaCwwtmpdDmJLUjYoB/gWdK+uf2WGdVcOc3O3WaSYbKlLruN"
}