# ami image info
# launch an instance
# copy the AMI ID (for 64-bit(x86) Architecture) ami-05f3141013eebdc12
# click on AMIs under Images section, choose Public image from 
# d drop down. past d AMI ID to get the owner and values(AMI name)


data "aws_ami" "instance_ami" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220805.0-x86_64-gp2"]
  }

}
