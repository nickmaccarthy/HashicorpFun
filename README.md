

Requirements
-------------
* terrform 0.9.1+
* packer 0.12.13+
* ansible 2+
* AWS account with credentials sufficient to build services with a credentials file profile called `hashicorp`

Steps
--------


* Clone this repo
* Build the VPC
  *
```
cd terraform/vpc
terraform plan  
terraform apply
```
  * Grab the VPC id that was generated here, we will need it for the next step
* Pack the AMI
  *  In the `packer` directory, copy `vars.json.example` to `vars.json` and fill in variables
    * access_key and secret_key - keys for a user in an AWS account with privs to build
    * ssh_key_path - path to your local ssh keypair to use on this host so you can ssh in after its been provisioned
    * vpc_id - the vpc_id we will build our ami in our vpc
  *
```
  cd packer
  packer validate -var-file=vars.json ec2ami/ami.json
  # If no errors, continue with the build
  packer build
  packer build -var-file=vars.json ec2ami/ami.json
```
* todo: Deploy new instances with our ami
* todo: Get the sevices to talk to eachother
