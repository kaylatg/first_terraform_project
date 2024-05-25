/* 
* Reference:
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
*/

/*
* Provides a Virtual Private Cloud (VPC) resource.
*/
resource "aws_vpc" "my_vpc" {
    // classless inter-domain routing block
    // a group of IP addresses that share the same network prefix and number of bits
    // length of the prefix determines the size of the block
    // smaller prefix = larger block/more addresses and vice versa
    cidr_block = "10.123.0.0/16" // prefix = 16 (16 bits used for each network)
    enable_dns_hostnames = true // defaults to false
    // enable_dns_support defaults to true
    
    tags = {
        Name = "dev" // I know that this is my dev vpc when I go searching
    }
}