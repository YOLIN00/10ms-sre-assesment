
variable "region" {
  type    = string
  default = "ap-south-1" // Mumbai
}

variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_id" {
  type    = string
  default = "ami-02b8269d5e85954ef" //ubuntu 20.04 LTS in ap-south-1
}

variable "s3_backend_bucket" {
  type = string
  default = "10mssre-terraform-backend-bucket"
}