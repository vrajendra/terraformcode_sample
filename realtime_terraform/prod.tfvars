prefix = "prod"
region = "us-east-1"
cidr_blocks = {
    public1      = "10.1.0.0/16"
    #public1   = "10.1.1.0/24"
    #public2	  = "10.1.2.0/24"
    #private1  = "10.1.3.0/24"
    #private2  = "10.1.4.0/24"
    }
instance_count = 6
subnet_count = 2
key_name = "terraformec2keypair"