#!/bin/sh

# Genereate the ec2 inventory
env/bin/python inventory_generator.py

# run ansible
env/bin/ansible-playbook -i inventory/ansible_aws_inventory cluster.yml 
