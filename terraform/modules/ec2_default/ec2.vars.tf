variable "region" {
    description = "AWS Region to deploy to"
    default = "us-east-1"
}
variable "hostname" {
    description = "Hostname for this instance"
}
variable "private_ip_address" {
    description = "IP Address to associate with the instance"
}
variable "instance_type" {
    description = "Instance type"
    default = "t2.small"
}
variable "availability_zone" {
    description = "The AZ associated with the subnet"
    default = "us-east-1a"
}
variable "keyname" {
  default = "hashicorp"
}
variable "cluster" {
  description = "The cluster the instance is in"
}
