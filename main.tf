/* 
* References:
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
* https://registry.terraform.io/providers/hashicorp/aws/3.24.1/docs/resources/internet_gateway
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table.html
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
* https://developer.hashicorp.com/terraform/language/functions/file
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
*/

/*
* Provides a Virtual Private Cloud (VPC) resource.
* A logically isolated virtual network that you've defined 
*
* classless inter-domain routing block
* a group of IP addresses that share the same network prefix and number of bits
* length of the prefix determines the size of the block
* smaller prefix = larger block/more addresses and vice versa
*
* enable_dns_support defaults to true
*/
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.123.0.0/16" // prefix = 16 (16 fixed bits in the range of addresses)
  enable_dns_hostnames = true            // defaults to false

  tags = {
    Name = "dev" // I know that this is my dev vpc when I go searching
  }
}

/*
* Provides a VPC subnet resource.
* This VPC subnet resource has been specified as public.
* 
* Every AZ has at least one data center and is connected to the Internet.
*/
resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.123.1.0/24" // one of the subnets within the vpc /16 
  map_public_ip_on_launch = true            // instances launched into subnet assigned public IP address
  availability_zone       = "us-east-1a"    // geographic region where AWS resources are stored

  tags = {
    Name = "dev-public"
  }
}

// Provides a resource to create a VPC Internet Gateway.
// Allows communication between your VPC and the internet
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

/*
* Provides a resource to create a VPC routing table.
*/
resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

/*
* Provides a resource to create a routing table entry (a route) in a VPC routing table.
* Route traffic from subnet to internet gateway
*/
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id // ref route table since I'm doing standalone not inline
  destination_cidr_block = "0.0.0.0/0"                     // all IP addresses will head for this internet gateway
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

/*
* Provides a resource to create an association between a route table and a 
* subnet or a route table and an internet gateway or virtual private gateway.
* Bridging the gap between route table and subnet
*/
resource "aws_route_table_association" "my_route_table_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_rt.id
}

/*
* Provides a security group resource.
* Controls the traffic that is allowed to reach and leave the resources that it is associated with
*/
resource "aws_security_group" "my_sg" {
  name        = "dev_sg" // no need to tag because sg actually has a name attribute
  description = "dev security group"
  vpc_id      = aws_vpc.my_vpc.id

  // inbound traffic
  ingress {
    from_port   = 0 // from and to ports must be 0 if protocol = -1
    to_port     = 0
    protocol    = "-1"          // all kinds of traffic (i.e. TCP, UDP,...)
    cidr_blocks = ["0.0.0.0/0"] // replace with local computer ip/32 to indicate only this address
  }

  // outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // allow whatever goes into the subnet to access anything (open internet)
  }
}

/*
* Provides an EC2 key pair resource. A key pair is used to control login access to EC2 instances.
*/
resource "aws_key_pair" "my_auth" {
  key_name   = "mykey"
  public_key = file("~/.ssh/mykey.pub") // reads the contents of the file at path and returns them as string
}

/*
* Provides an EC2 instance resource. This allows instances to be created, updated, and deleted.
*/
resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.my_auth.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = aws_subnet.my_public_subnet.id
  user_data              = file("userdata.tpl") // extract data from tpl file and use it to bootstrap instance

  // Configuration block to customize details about the root block device of the instance.
  root_block_device {
    volume_size = 10 // default 8
  }

  tags = {
    Name = "dev-node"
  }

}