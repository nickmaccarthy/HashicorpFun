#!/bin/bash

# sets our hostname
IP=$(/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

/bin/echo -e "$IP ${hostname}\n127.0.0.1 localhost localhost.localdomain" > /etc/hosts
/bin/sed -i "s/^HOSTNAME=.*$/HOSTNAME=${hostname}/" /etc/hostname
/bin/hostname ${hostname}
