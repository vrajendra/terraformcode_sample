# IAM Access and Secret Key for your IAM user
aws_access_key = "AKIAT3FW26V6DJ4D7ZU3"

aws_secret_key = "OcR0br1cmP6BlmonC2EG9lSnsjjnMcVjzAp5AAWT"

# Name of the key pair in AWS, MUST be in same region as EC2 instance
# Check README for AWS CLI commands to create a key pair
key_name = "terraformec2keypair"

# Local path to pem file for key pair. 
# Windows paths need to use double-backslash: Ex. C:\\Users\\Ned\\Pluralsight.pem
private_key_path = "C:\\terraform\\aws\\terraformec2keypair.pem" 
