variable "db_name" {
    description = "postgresql db name"
    type = string
  
}

variable "db_user_name" {
    description = "postgresql db username"
    type = string  
}
variable "db_password" {
    description = "postgresql db password"
    type = string
  
}
variable "postgres_tags" {
    type = map(string)
    default = { }
  
}
variable "database_subnet_group_name" {
    type = string
  
}