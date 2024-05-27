/* 
* References:
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
*/

/*
* Provides a Virtual Private Cloud (VPC) resource.
*/
resource "aws_vpc" "my_vpc" {
    // classless inter-domain routing block
    // a group of IP addresses that share the same network prefix and number of bits
    // length of the prefix determines the size of the block
    // smaller prefix = larger block/more addresses and vice versa
    cidr_block = "10.123.0.0/16" // prefix = 16 (16 fixed bits in the range of addresses)
    enable_dns_hostnames = true // defaults to false
    // enable_dns_support defaults to true
    
    tags = {
        Name = "dev" // I know that this is my dev vpc when I go searching
    }
}

/*
* Provides a VPC subnet resource.
* This VPC subnet resource has been specified as public.
*/
resource "aws_subnet" "my_public_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.123.1.0/24" // one of the subnets within the vpc /16 
    // Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
    map_public_ip_on_launch = true 
    //An Availability Zone (AZ) is a geographic region in which AWS resources are stored. 
    //Every AZ has at least one data center and is connected to the Internet.
    availability_zone = "us-east-1a"

    tags = {
        Name = "dev-public"
    }
}