#Set variables in the variables.tf file

#Sets the AWS region
provider "aws" {
  region = var.region
}

#Creates a key pair so we can login to the instance
resource "aws_key_pair" "deployer" {
  key_name   = var.keyname
  public_key = var.keypair
}

#Creates a security group that allows ssh from anywhere. Restricts sql port 3306 to the internal VPC only.
resource "aws_security_group" "cms" {
  name        = "cms"
  description = "Allow SSH from anywhere and mysql from VPC"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["sg-0b252d6b"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cms"
  }
}

#Creates a new EC2 instance
resource "aws_instance" "web" {
  ami             = "ami-0eab3a90fc693af19"
  instance_type   = "t2.micro"
  key_name        = var.keyname
  security_groups = ["cms", "default"]

  tags = {
    Name = "HelloWorld"
  }
}