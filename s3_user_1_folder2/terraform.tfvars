# IAM Access and Secret Key for your IAM user
aws_access_key = "replace"

aws_secret_key = "replace"

# Name of the key pair in AWS, MUST be in same region as EC2 instance
# Check README for AWS CLI commands to create a key pair
key_name = "replacekeypairname"

# Local path to pem file for key pair. 
# Windows paths need to use double-backslash: Ex. C:\\Users\\Ned\\Pluralsight.pem
private_key_path = "C:\\terraform\\aws\\pemfilename" 

# Prefix value to be used for S3 bucket. You can leave this value as-is
bucket_name_prefix = "globo"

# Environment tag for all resources being created. You can leave this value as-is.
environment_tag = "dev"

# Made up billing code to be added as a tag to resources. You can leave this value as-is.
billing_code_tag = "tagname"
