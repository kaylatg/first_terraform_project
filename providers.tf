/*
* Use the Amazon Web Services (AWS) provider to interact with 
* the many resources supported by AWS. You must configure the 
* provider with the proper credentials before you can use it.
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs
*/
terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

/*
* The AWS Provider can source credentials and other settings from 
* the shared configuration and credentials files. Here I am using 
* parameters, but I could use environment variables instead such as
* AWS_PROFILE, AWS_CONFIG_FILE, and AWS_SHARED_CREDENTIALS_PROFILE.
* I also could have not named the profile because it would have used
* the default profile by default.
*/
provider "aws" {
    region = "us-east-1"
    //shared_config_files      = ["/Users/tf_user/.aws/conf"]
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "default"
}