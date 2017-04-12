provider "aws" {
    region = "us-east-1"
    profile = "hashicorp"
}

module "consul1" {
    source = "../modules/ec2_default"
    hostname = "consul1"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    private_ip_address = "192.168.77.20"
    cluster = "consul"
}


module "consul2" {
    source = "../modules/ec2_default"
    hostname = "consul2"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    private_ip_address = "192.168.77.21"
    cluster = "consul"
}

module "vault" {
    source = "../modules/ec2_default"
    hostname = "vault"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    private_ip_address = "192.168.77.25"
    cluster = "vault"
}

module "appserver" {
    source = "../modules/ec2_default"
    hostname = "appserver"
    instance_type = "t2.small"
    availability_zone = "us-east-1a"
    private_ip_address = "192.168.77.10"
    cluster = "appserver"
}

# find the hashicorp vpc
data "aws_vpc" "hashicorp" {
  tags {
    Name = "hashicorp-vpc"
  }
}
# find our hashicorp security group
data "aws_security_group" "hashicorp" {
  vpc_id = "${data.aws_vpc.hashicorp.id}"
  name = "hashicorp"
}

resource "aws_security_group_rule" "allow_ports" {
  security_group_id = "${data.aws_security_group.hashicorp.id}"

  type = "ingress"
  from_port = 8000
  to_port = 9000
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]

}

resource "aws_security_group_rule" "allow_web_ports" {
  security_group_id = "${data.aws_security_group.hashicorp.id}"

  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]

}
