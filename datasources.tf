/*
* References:
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
* https://developer.hashicorp.com/terraform/language/functions/file
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
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
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"] // ami name
  }
}

/*
* Provides an EC2 key pair resource. A key pair is used to control login access to EC2 instances.
*/
resource "aws_key_pair" "my_auth" {
    key_name = "mykey"
    public_key = file("~/.ssh/mykey.pub") // reads the contents of the file at path and returns them as string
}

/*
* Provides an EC2 instance resource. This allows instances to be created, updated, and deleted.
*/
resource "aws_instance" "dev_node" {
    instance_type = "t2.micro"
    ami = data.aws_ami.server_ami.id

    tags = {
        Name = "dev-node"
    }

    key_name = aws_key_pair.my_auth.id
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = aws_subnet.my_public_subnet.id

    // Configuration block to customize details about the root block device of the instance.
    root_block_device {
        volume_size = 10
    }
}