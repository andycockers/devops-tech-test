Requirements:

Terraform 0.12.21

Ansible 2.9.5

AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

Add an AWS user with Programmatic access and give it access to AWS resources.

Run aws configure to allow Terraform to use the AWS user credentials.

To create a keypair in AWS for use with an EC2 instance:

1. If you don't already have one, run ssh-keygen to create a public/private keypair

2. cd andyc/terraform/modules/ec2

3. In the variables.tf file, add your public key

To create compute and security rules:

1. cd andyc/terraform/modules/ec2

2. Edit variables.tf and change entries as appropriate. I have used eu-west-2. Bear in mind that the database in the next section should be in the same region as the compute resources.

3. terraform init

4. terraform plan

5. terraform apply (or if you are feeling brave terraform apply --auto-approve)

When it's finished, make note of the aws_security_group id - we will need this to create the database.

To create the database.

1. cd andyc/terraform/modules/rds

2. Edit variables.tf, enter values for db_pass and security_group_id (the aws_security_group id from the ec2 task)

3. terraform init

4. terraform plan

5. terraform apply (or if you are feeling brave terraform apply --auto-approve)

6. Make a note of the id that is produced at the end as this will be needed later to destroy the database.

7. Once the database has been created, open a browser and navigate to https://eu-west-2.console.aws.amazon.com/rds/home?region=eu-west-2#databases:

8. Select the new instance and make a note of the endpoint.

Ansible configuration.

1. cd andyc/ansible

To get the ec2 public dns:

The role (not actually a role) inventory-source queries AWS for instances in the specified region. See https://docs.ansible.com/ansible/latest/plugins/inventory/aws_ec2.html for more information.

The plugin requires boto3 and botocore which can be installed with pip

To query AWS:

1. source vars.sh (need to add EC2 access key and secret key)

2. ansible-inventory -i roles/inventory-source/tasks/andyc.aws_ec2.yml --graph

This will produce output similar to:

@all:
  |--@aws_ec2:
  |  |--ec2-35-178-58-224.eu-west-2.compute.amazonaws.com
  |--@ungrouped:

4. Copy the string "ec2-35-178-58-224.eu-west-2.compute.amazonaws.com" to the Ansible inventory file in andyc/ansible/inventory

Database settings for mezzanine CMS

1. cd andyc/ansible/roles/mezzanine/files

2. Edit local_settings.py

3. Change PASSWORD to the password used when creating the db.

4. Change HOST to the endpoint of the db.

Provisioning using Ansible.

1. cd andyc/ansible

2. ansible-playbook -i inventory --private-key /path/to/private-key -u centos playbook.yml

What the playbook does.

Installs yum dependencies.

Installs mezzanine cms server usig pip3 http://mezzanine.jupo.org/

Configures mezzanine cms server against the rds db that was created using TF

Installs gunicorn https://gunicorn.org/ to run mezzanine as a unix sock service

Copy the gunicorn service file, enable and start the service.

Create self signed ssl keys.

Once it has finished, a mezzanine server will be running on a unix socket. To test it, run:

curl -X GET --unix-socket /home/centos/cms/cms.sock http://localhost:8000

Destroying the infrastructure:

1. cd andyc/terraform/modules/ec2

2. terraform destroy (or terraform destroy --auto-approve)

3. It is not possible to delete the db using terraform. An alternative is to use the aws cli.
   cd andyc/terraform/modules/rds pass the db id that was produced during create to deletedb.sh


Notes:

I'm using Python 3 pip3 to install mezzanine cms and dependencies. Python 2.7 was deprecated in January 2020 and errors are returned attempting to install mysqlclient using Python 2.7 pip.

I could not use letsencrypt to generate a certificate as this is not allowed by letsencrypt for AWS ec2 servers with ephemeral public dns names, so I used Ansible's openssl role to generate self signed certs.

However, that's as far as I've managed to get. I've had no luck getting a reverse proxy to work using nginx, either http or https. I think this must be to do with not having a domain I can use for testing. My knowledge of reverse proxy setup is slight, despite running one at home.

