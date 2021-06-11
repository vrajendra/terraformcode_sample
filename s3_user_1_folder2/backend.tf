terraform {  
    backend "s3" {
        bucket         = "terraform-backend-store-vivektest1111"
        encrypt        = true
        key            = "terraform.tfstate"    
        region         = "us-east-1"
        dynamodb_table = "terraform-state-lock-dynamo-vivektest1111111"
    }
}