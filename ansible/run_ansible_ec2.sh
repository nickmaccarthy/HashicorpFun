#!/bin/sh

dirname=`dirname $BASH_SOURCE`

echo "Generating ec2 inventory for ansible..."
# Genereate the ec2 inventory
$dirname/env/bin/python $dirname/inventory_generator.py

echo "Running ansible against our ec2 inventory..."
# run ansible
$dirname/env/bin/ansible-playbook -i $dirname/inventory/ansible_aws_inventory $dirname/cluster.yml
