provider "aws" {
  region = "us-east-1"
  # Have an aws profile in .aws/credentials for hashicorp
  profile = "hashicorp"
}

resource "aws_vpc" "hashicorp_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "hashicorp-vpc"
  }
}

resource "aws_security_group" "hashicorp" {
  name = "hashicorp"
  description = "Allow all inbound traffic for the hashicorp code test"
  vpc_id = "${aws_vpc.hashicorp_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
