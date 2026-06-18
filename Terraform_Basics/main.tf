provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "First_VPC" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "first_vpc"

    }
}

resource "aws_subnet" "subnet1"{
    vpc_id = aws_vpc.First_VPC.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2"{
    vpc_id = aws_vpc.First_VPC.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.First_VPC.id
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.First_VPC.id

route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
}
}

resource "aws_route_table_association" "subnet1_association" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "subnet2_association" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "web_sg" {

    vpc_id = aws_vpc.First_VPC.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web_server"{
    ami ="ami-0b6d9d3d33ba97d99"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    subnet_id = aws_subnet.subnet1.id
    key_name = "firstKeyPair"

    tags = {
        Name = "web_server"
    }
}


output "web_server_public_ip" {
    value = aws_instance.web_server.public_ip
}