import sys
import os
import argparse
import re
from time import time
import boto
from boto import ec2
from boto import rds
from boto import elasticache
from boto import route53
from boto import sts
import six
from pprint import pprint
import ConfigParser
parser = ConfigParser.ConfigParser()

from ansible.module_utils import ec2 as ec2_utils

HAS_BOTO3 = False
try:
    import boto3
    HAS_BOTO3 = True
except ImportError:
    pass

from six.moves import configparser
from collections import defaultdict

try:
    import json
except ImportError:
    import simplejson as json

session = boto3.Session(profile_name='hashicorp')

ec2 = session.resource('ec2')

filters = [
    {
        "Name": "tag:Project", "Values": ["Hashicorp"]
    }
]

instances = ec2.instances.filter(Filters=filters)

hosts = {}
hosts['consul'] = [] 
hosts['vault'] = []
hosts['appserver'] = []
for instance in instances:
    pub_ip = instance.public_ip_address
    tags = { tag['Key']:tag['Value'] for tag in instance.tags }
    hosts[tags['cluster']].append( { 'name': tags['Name'], 'ip': pub_ip } )

for cluster, details in hosts.items():
    parser.add_section(cluster)
    for detail in details:
        key = "{name} ansible_ssh_host={ip} ansible_ssh_user=ubuntu ansible_ssh_common_args='-o StrictHostKeyChecking=no'".format(name=detail['name'], ip=detail['ip'])
        parser.set(cluster, key, '')

with open('inventory/ansible_aws_inventory', 'w') as f:
    parser.write(f)
