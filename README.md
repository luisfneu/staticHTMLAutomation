# POC
Static website with S3 public

## start from beginning 

* download projet from github 
##### clone project: 
	git clone https://github.com/luisfneu/terraform.git

* after clone project, set folder as terraform project 
##### start terraform 
    terraform init

* to set up your communication with AWS, is recoment to use IAM user, and set credentials in your enviroment.

## run

* is simple
##### apply code with terraform in AWS
    terraform apply
    
*  confirm typing 'yes'

At the end the the command will output your URL to access your landing page.

## finally

* destroy evething on your lab
##### destroy all the lab
    terraform destroy

*  confirm typing 'yes'