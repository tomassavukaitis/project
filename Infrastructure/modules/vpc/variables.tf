variable "azs" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b"]  
}

variable "vpc_cidr" {
  type    = string 
}

variable "private_subnet_cidrs" {
  type = list(string)
}