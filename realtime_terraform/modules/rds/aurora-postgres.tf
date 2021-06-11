resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.postgres_cluster.id
  instance_class     = "db.r4.large"
  engine             = "aurora-postgresql"
  engine_version     = 11.9
  tags = var.postgres_tags
}

resource "aws_rds_cluster" "postgres_cluster" {
  cluster_identifier = "aurora-cluster-demo"
  db_subnet_group_name = var.database_subnet_group_name
  engine             = "aurora-postgresql"
  database_name      = var.db_name
  master_username    = var.db_user_name
  master_password    = var.db_password
  skip_final_snapshot = true
  tags = var.postgres_tags
}