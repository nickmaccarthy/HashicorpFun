# Hashicorp Service Testing

The purpose of this repo is to demonstrate the build, configuration and deployment of Hashicorp products and services.  

The Hashicorp products covered in this are:
* Vagrant
* Terraform
* Packer
* Consul
* Consul-Template
* Vault


# Requirements
----------------
* Terraform 0.9.1+
* Packer 0.12.13+
* Ansible 2+ ( `pip install ansible` )
* AWS account with credentials sufficient to build services with a credentials file profile called `hashicorp`
* Python 2.7
* Python pip
* Python virtualenv

# AWS Build Steps
-------------------

Instructions to build this in AWS.  Please follow instructions in order.

Note, these instructions assume that `$PROJECT_HOME` is the directory where you have cloned this repo.  Mostly everything revolves around this directory

* Clone this repo
* Create an `AWS_PROFILE` in `~/.aws/credentials` named `hashicorp` with an access and secret key with priv's to build our assets.
  * example `~/.aws/credentials` file
  * NOTE: This is a required step, as everything involving AWS in the rest of the steps below requires that `AWS_PROFILE` be present
```
[hashicorp]
aws_access_key_id=<KEY>
aws_secret_access_key=<KEY>
region=us-east-1
```
* Set `AWS_PROFILE`.  In a terminal, run the following to set our `hashicorp` credentials as the default for `packer`, `terraform`, etc
  * `export AWS_PROFILE=hashicorp`
  * Note, if you are using multiple terminals, you will have to do this for each session
* Use Terraform to build our VPC  
  * `cd $PROJECT_HOME/terraform/vpc && terraform plan && terraform apply`
```
cd $PROJECT_HOME/terraform/vpc
terraform plan  
terraform apply
```
* Create an ec2 keypair named `hashicorp` and place it in `~/.ssh` locally
  * If you dont want to create a new keypair, simply override the `hashicorp` keypair in the Terraform ec2 build step with whatever keypair you want to use
* Use Packer to make an AMI for us Pack the AMI
  *  In `vars.json` fill in the location to your local ssh key, packer will copy your ssh key in to the AMI so you can SSH into the instance after you have built it
```
  cd $PROJECT_HOME/packer
  packer validate -var-file=vars.json hashiami/ami.json
  # If no errors, continue with the build
  packer build -var-file=vars.json hashiami/ami.json
```
* Build our ec2 instances in our VPC with Terraform
```
  cd $PROJECT_HOME
  cd terraform/cluster
  terraform get
  terraform plan
  terraform apply
```
* Build inventory file for Ansible for use in next step
```
  cd $PROJECT_HOME/ansible
  virtualenv env
  source env/bin/activate
  pip install -r pip_requirements.txt
  python inventory_generator.py
```
* Now run ansible to configure our hosts and get the cluster(s) up and running
```
  cd $PROJECT_HOME/ansible
  ansible-playbook -i inventory/ansible_aws_inventory cluster.yml
```
  * Note: This might take a few minutes to complete
* Check to see if everything is up and running
  * Point browser to the IP address of your appserver, you should see confirmation things are working
  * Point your browser to the IP address of one of the consul servers, http://<consulIP>:8500 , you should see the consul ui page

# Vagrant Build Steps
-------------------------

Instructions to get this going in Vagrant, locally.  Consul, Vault, etc were tested in a local Vagrant environment first before it was built in AWS .

* Go into the project_home and run vagrant up
```
  cd $PROJECT_HOME
  vagrant up
```
* To see the appserver point a browser to `http://192.168.77.10`
* To see a Consul UI, point a browser to `http://192.168.77.20`
