# ec2 module
data "template_file" "user_data" {
    template = "${file("${path.module}/templates/userdata.sh")}"
    vars {
        hostname = "${var.hostname}"
    }
}

data "aws_caller_identity" "current" {}

# find hashicorp ami
data "aws_ami" "hashicorp" {
  #owners = ["${data.aws_caller_identity.current.account_id}"]
  most_recent = true
  filter {
    name = "name"
    values = ["hashicorp-*"]
  }
  filter {
    name = "owner-id"
    values = [ "${data.aws_caller_identity.current.account_id}" ]
  }
}
# find the hashicorp vpc
data "aws_vpc" "hashicorp-vpc" {
  tags {
    Name = "hashicorp-vpc"
  }
}
# find our hashicorp security group
data "aws_security_group" "hashicorp" {
  vpc_id = "${data.aws_vpc.hashicorp-vpc.id}"
  name = "hashicorp"
}
# find our subnet in the hashicorp vpc
data "aws_subnet" "hashi-subnet" {
  vpc_id = "${data.aws_vpc.hashicorp-vpc.id}"
  tags {
    Name = "hashicorp-${var.availability_zone}"
  }
}

resource "aws_instance" "ec2_instance" {
    ami = "${data.aws_ami.hashicorp.id}"
    instance_type = "${var.instance_type}"
    vpc_security_group_ids = [ "${data.aws_security_group.hashicorp.id}" ]
    subnet_id = "${data.aws_subnet.hashi-subnet.id}"
    availability_zone = "${var.availability_zone}"
    user_data = "${data.template_file.user_data.rendered}"
    associate_public_ip_address = true
    private_ip = "${var.private_ip_address}"
    key_name = "${var.keyname}"
    tags {
        Name = "${var.hostname}"
        Project = "Hashicorp"
        cluster = "${var.cluster}"
        role = "${var.cluster}"
    }
}

output "public_ip" {
  value = "${aws_instance.ec2_instance.public_ip}"
}
output "private_ip" {
  value = "${aws_instance.ec2_instance.private_ip}"
}
