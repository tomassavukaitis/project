provider "aws" {
  region = "eu-west-1" 
}

resource "aws_ecr_repository" "image_repo" {
  name                 = "image_repo"
  image_tag_mutability = "MUTABLE" 
}

