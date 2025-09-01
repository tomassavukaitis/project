provider "aws" {
  region = "eu-west-1" 
}

resource "aws_instance" "jenkins_host" {
  ami           = "ami-0bc691261a82b32bc"  
  instance_type = "t2.small"
  key_name      = "Tomas-Key"          
  subnet_id              = var.subnet_id
  
  vpc_security_group_ids = [var.jenkins_sg_id]
  tags = {
    Name = "jenkins_host"
  }
}
