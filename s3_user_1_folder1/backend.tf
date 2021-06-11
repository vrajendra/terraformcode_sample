terraform {  
    backend "s3" {
        bucket         = "terraform-backend-store-vivektest111"
        encrypt        = true
        key            = "terraform.tfstate"    
        region         = "us-east-1"
        dynamodb_table = "terraform-state-lock-dynamo-vivektest111"
    }
}