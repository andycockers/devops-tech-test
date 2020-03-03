#Set variables in the variables.tf file

#Sets the AWS region

provider "aws" {
  region = var.region
}
#Creates a new RDS mysql instance 
resource "aws_db_instance" "default" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_user
  password               = var.db_pass
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = var.security_group_id
  
}