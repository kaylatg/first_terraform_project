This project was developed by following the Derek Morgan's YouTube tutorial 
accessible via this address: https://www.youtube.com/watch?v=iRaai1IBlB0

The project description as seen on YouTube is as follows: Learn Terraform basics 
as you utilize Visual Studio Code (On Windows, Mac, or Linux!) to deploy AWS resources 
and an EC2 instance that you can SSH into to have your own redeployable environment.

.gitignore contains:
.terraform/providers/registry.terraform.io/hashicorp/aws/5.51.1/darwin_amd64/terraform-provider-aws_v5.51.1_x5

terraform commands:
    terraform init - initialized terraform
    terraform plan - shows execution plan + see required infrastructure changes
    terraform apply - creates the vpc 
        (add -auto-approve to avoid confirmation dialogue)
    terraform show - shows the entire state (state show requires you to input a resource)
    terraform destroy - destroys all remote objects managed by a particular terraform configuration 
        (deletes everything applied)
    terraform plan -destroy - shows proposed destroy changes without executing them 
        (add -auto-approve to avoid confirmation dialogue)
    terraform state list - list of resources
        (vpc id, not a String, but a reference to a resource)
    terraform state show aws_vpc.my_vpc - shows vpc attributes