variable "region" {
  description = "The AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "db_name" {
  description = "The name of the db"
  type        = string
  default     = "cmsdb"
}

variable "db_user" {
  description = "Username"
  type        = string
  default     = "cmsuser"
}

variable "db_pass" {
  description = "Password"
  type        = string
  default     = ""
}
#The security group id that is produced when creating the ec2 instance, security and keypair.
variable "security_group_id" {
  description = "The cms security group id"
  type        = list(string)
  default     = [""]
  
}
