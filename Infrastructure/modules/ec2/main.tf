provider "aws" {
  region = "eu-west-1" 
}

resource "aws_instance" "jenkins_host" {
  ami           = var.ami_id  
  instance_type = var.instance_type
  key_name      = var.key_name         
  subnet_id     = var.subnet_id
  
  vpc_security_group_ids = [var.jenkins_sg_id]
  tags = {
    Name = "jenkins_host"
  }
}
