/*
* References:
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
*/

/*
* Use this data source to get the ID of a registered AMI for use in other resources.
* An Amazon Machine Image (AMI) is a supported and maintained image provided by AWS 
* that provides the information required to launch an instance.
*/
data "aws_ami" "server_ami" {
  most_recent = true             // If more than one result is returned, use the most recent AMI
  owners      = ["099720109477"] // owner account id

  // One or more name/value pairs to filter off of.
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] // ami name
  }
}
