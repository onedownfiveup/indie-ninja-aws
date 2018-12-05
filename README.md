# AWS dev ops repository (Infrastructure as code)

 
![Continous integration/Deployment diagram](https://github.com/onedownfiveup/indie-ninja-aws/blob/master/indie.ninja_API_continous_deployment_cloudformation_stack.png "Logo Title Text 1")

## What is in the box?
This repository contains the code to build the infrastructure for the indie.ninja API. The repository has 2 folders:

* packer - This directory contains the files and setup for building your base AMI for your ecs task definitions
* cloudformation - This directory contains the cloudformation stack templates for building the AWS infrastrucutre. 

The code for this repository was inspired by reading: [Docker on Amazon Web Services](http://a.co/d/hvu7Bx1) and also using 
the [awslabs/ecs-refarch-continuous-deployment](https://github.com/awslabs/ecs-refarch-continuous-deployment) as a resource 
for splitting out templates and building the CodePipeline stack.


## Why did we need this?

I am not a dev ops engineer and my days of hacking on linux boxes to configure my workspace are behind me. I found myself hacking 
together a production environment and having to google along the way on setting up permissions, ec2 instances, Vpcs, subnets 
etc.. and if you asked me to build it again I probably would have to research everything again as I am a developer and I do
not do dev ops on a daily basis. 

Furthermore all the information about how to set up the production environment is mostly in my head and scattered in random 
confluence docs. If someone were to need to replicate it in the future or my future self forgets they will have to reverse
engineer what is currently in place. Not ideal.

## How to use

### Pre requisites

* Packer 1.0 or higher (instructions will be provided on how to install Packer)
* Administrator access to an AWS account
* Local AWS profile configured as per the instructions in Chapter 3
* GNU Make version 3.82 or higher (note that macOS does not ship with this version by default)
* AWS CLI 1.15.71 or higher
* jq: A command-line utility for parsing JSON
* A link to a public S3 bucket that you own

I have not made this a template yet so there are a lot of references to indie.ninja in the stack names and the configuration files.
You should rename them (obviously)

### Packer 
#### Create your AMI image
You can create your Linux AMI by navigating to the packer repository and runing the `make build` command. You should change the 
name of your images and make any customizations before running.

```shell
edit [ cmavromoustakos ~/Sandbox/indie-ninja/indie-ninja-aws/packer master ] make build
amazon-ebs output will be in this color.

==> amazon-ebs: Prevalidating AMI Name: indie-ninja-api-1544035381
    amazon-ebs: Found Image ID: ami-07eb698ce660402d2
==> amazon-ebs: Creating temporary keypair: packer_5c081c37-3f48-554b-56e1-2a1ab2a1a927
==> amazon-ebs: Creating temporary security group for this instance: packer_5c081c39-d176-9104-3b63-128b2d01786a
==> amazon-ebs: Authorizing access to port 22 from 0.0.0.0/0 in the temporary security group...
==> amazon-ebs: Launching a source AWS instance...
==> amazon-ebs: Adding tags to source instance
    amazon-ebs: Adding tag: "Name": "Packer Builder"
    amazon-ebs: Instance ID: i-0604fb9e6add8ea4b
==> amazon-ebs: Waiting for instance (i-0604fb9e6add8ea4b) to become ready...

```


### CloudFormation
You should edit the [dev.json](https://github.com/onedownfiveup/indie-ninja-aws/blob/master/cloudformation/dev.json) file and 
replace with whatever your configuration is. 

#### Create your AWS Key Management Store
You can run `make create-kms`

#### Create your AWS Elastic Container Repository
You can run `make create-ecr-repo`

#### Upload your stacks to an S3 bucket
You should have seen the reference to the `TemplateBucket` in the dev.json file. You will need to update your configuration to
point to your *public* S3 bucket. You will also need to replace the template name in the Makefile for the `uopload-stacks` Makefile
task. 

Once you have done the above you can run `make upload-stacks` 

#### Create the AWS stacks
You can simply run `make deploy/dev` and this will deploy all the stacks using

At this point assuming you have changed the GiuthubRepo configuration to the configuration you have specified you should be
able to push your app and have the build trigger and deploy the updated code.


## License

This reference architecture sample is licensed under Apache 2.0.
