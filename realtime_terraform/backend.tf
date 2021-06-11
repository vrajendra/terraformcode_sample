terraform {  
    backend "s3" {
        bucket         = "terraform-backend-store-vivektest"
        encrypt        = true
        key            = "terraform.tfstate"    
        region         = "us-east-1"
        dynamodb_table = "terraform-state-lock-dynamo-vivektest"
    }
}