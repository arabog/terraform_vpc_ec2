# inputs
variable "vpc_ec2" {
  type        = string
  default     = "vpc_ec2_network"
  description = "A reference to the Input VPC"
}

variable "public_subnet" {
  type        = string
  default     = "ec2_public_subnet"
  description = "A reference to the Input Public Subnet"
}

# sec grp
resource "aws_security_group" "ec2_sec_grp" {
  name        = "instance_sg"
  description = "instance security group"
  vpc_id      = aws_vpc.vpc_ec2.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_sec_grp"
  }
}


# key pair
# ssh-keygen -t ed25519
# rename path by copying: /home/aduke/.ssh/ and wtever u like like /home/aduke/.ssh/babskey
# press enter to use default
# run ls ~/.ssh u shd see babskey
resource "aws_key_pair" "babs" {
  key_name   = "babs0922"
  public_key = file("~/.ssh/babskey.pub")
}

# # linux instance
resource "aws_instance" "instance" {
  ami                    = data.aws_ami.instance_ami.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.babs.id
  vpc_security_group_ids = [aws_security_group.ec2_sec_grp.id]
  subnet_id              = aws_subnet.public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "server"
  }
}