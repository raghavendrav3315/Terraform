terraform{
    backend "s3" {
        bucket = "my-terraform-statefile-bucket123"
        key = "dev/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "my-terraform-statefile-lock-table"      
    }
}