variable "az" {
  default = "us-east-1a"
}
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = "us-east-1"
  # Have an aws profile in .aws/credentials for hashicorp
  profile = "hashicorp"
}

resource "aws_vpc" "hashicorp" {
  cidr_block = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "hashicorp-vpc"
  }
}

/*
resource "aws_subnet" "hashicorp-public" {
  vpc_id = "${aws_vpc.hashicorp.id}"
  cidr_block = "192.168.88.0/24"
  availability_zone = "${var.az}"
  tags {
    Name = "hashicorp-public-${var.az}"
  }
}
*/

resource "aws_subnet" "hashicorp-default" {
  vpc_id     = "${aws_vpc.hashicorp.id}"
  cidr_block = "192.168.77.0/24"
  availability_zone = "${var.az}"

  tags {
    Name = "hashicorp-${var.az}"
  }
}

# create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.hashicorp.id}"
  tags {
        Name = "hashicorp-internet-gateway"
    }
}

# route it to the internet
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.hashicorp.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_eip" "hashicorp" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.hashicorp.id}"
    subnet_id = "${aws_subnet.hashicorp-default.id}"
    depends_on = ["aws_internet_gateway.gw"]
}


resource "aws_route_table" "public_route_table" {
    vpc_id = "${aws_vpc.hashicorp.id}"
    tags {
        Name = "hashicorp-private-route-table"
    }
}

resource "aws_route" "public_route" {
  route_table_id = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nate_gateway.nat.id}"
}

/*
resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}
*/

/*
# Associate subnet public_subnet_eu_west_1a to public route table
resource "aws_route_table_association" "hashicorp-public_association" {
    subnet_id = "${aws_subnet.hashicorp-public.id}"
    route_table_id = "${aws_vpc.hashicorp.main_route_table_id}"
}
*/

# Associate subnet private_1_subnet_eu_west_1a to private route table
resource "aws_route_table_association" "hashicorp-default_association" {
    subnet_id = "${aws_subnet.hashicorp-default.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}

resource "aws_security_group" "hashicorp" {
  name = "hashicorp"
  description = "Allow all inbound traffic for the hashicorp code test"
  vpc_id = "${aws_vpc.hashicorp.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }

}
