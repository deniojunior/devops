variable "ami" {
  default = "ami-2757f631"
}

variable "workers_count" {
  default = "2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2-user" {
  default = "ubuntu"
}

variable "application_name" {
  default= "voting-app"
}

variable "application_path" {
  default= "./voting-app"
}

variable "region" {
  default = "us-east-1"
}

variable "profile" {
  default = "swarm-cluster-deployer"
}
