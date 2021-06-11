
# the rest of your configuration and resources to deploy
# create-dynamodb-lock-table.tf
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo-vivektest"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
attribute {
    name = "LockID"
    type = "S"
  }
}