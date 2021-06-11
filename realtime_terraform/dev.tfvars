prefix = "dev"
region = "us-east-1"
cidr_blocks = {
    public1      = "10.0.0.0/16"
    #public1   = "10.0.1.0/24"
    #public2	  = "10.0.2.0/24"
    private1  = "10.0.3.0/24"
    private2  = "10.0.4.0/24"
    }
instance_count = 3
subnet_count = 3
key_name = "terraformec2keypair"
database_name = "postgresdb"
database_username = "vivek"
database_password = "876W796Y"