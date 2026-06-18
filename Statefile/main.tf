provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" "statefile_instance" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type = "t3.micro"
    tags = {
        Name = "statefile_instance"
    }
}


resource "aws_s3_bucket" "my-terraform-statefile-bucket123" {
    bucket = "my-terraform-statefile-bucket123"
}   

resource "aws_dynamodb_table" "my-terraform-statefile-lock-table" {
    name         = "my-terraform-statefile-lock-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
