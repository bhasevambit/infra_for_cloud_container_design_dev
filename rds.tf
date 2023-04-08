resource "aws_db_subnet_group" "sbcntr_rds_subnet_group" {
  description = "DB subnet group for Aurora"
  name        = "sbcntr-rds-subnet-group"
  subnet_ids  = ["subnet-0c6a1fc91df5e9c49", "subnet-0ff9153c02291d519"]
}

resource "aws_rds_cluster" "sbcntr_db" {
  cluster_identifier = "sbcntr-db"

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "5.7.mysql_aurora.2.11.1"

  backtrack_window                = "0"
  backup_retention_period         = "1"
  copy_tags_to_snapshot           = "true"
  database_name                   = "sbcntrapp"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  db_subnet_group_name            = aws_db_subnet_group.sbcntr_rds_subnet_group.name
  deletion_protection             = false #削除保護は、terraformでの一括destroyにて削除できるように「無効」とする
  skip_final_snapshot             = true  #terraformでの一括destroyにて削除できるように「有効」とし、スナップショットの作成をスキップする
  apply_immediately               = true  #terraformでの一括destroyにて削除できるように「有効」とする
  enable_http_endpoint            = "false"
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

  iam_database_authentication_enabled = "false"
  kms_key_id                          = "arn:aws:kms:ap-northeast-1:353981446712:key/155eb865-d799-42dc-a29e-2b13e1ed3c94"
  master_username                     = "admin"
  master_password                     = "VeryStrongPassword!" #仮設定. 後ほど変更
  network_type                        = "IPV4"
  port                                = "3306"
  preferred_backup_window             = "21:00-21:30"
  preferred_maintenance_window        = "sat:17:00-sat:17:30"
  storage_encrypted                   = "true"
  vpc_security_group_ids              = ["sg-09e06e8913054798d"]
}

resource "aws_rds_cluster_instance" "sbcntr-db-instance" {
  count = 2

  cluster_identifier = aws_rds_cluster.sbcntr_db.id

  auto_minor_version_upgrade   = "true"
  ca_cert_identifier           = "rds-ca-2019"
  copy_tags_to_snapshot        = aws_rds_cluster.sbcntr_db.copy_tags_to_snapshot
  db_subnet_group_name         = aws_db_subnet_group.sbcntr_rds_subnet_group.name
  engine                       = aws_rds_cluster.sbcntr_db.engine
  engine_version               = aws_rds_cluster.sbcntr_db.engine_version
  identifier                   = "sbcntr-db-instance-${count.index}"
  instance_class               = "db.t3.small" #terraform apply時の起動に非常に時間がかかるため、"db.t3.small"から"db.t3.large"へ変更を試したが、変化無かったため、"db.t3.small"に戻した
  monitoring_interval          = "60"
  monitoring_role_arn          = "arn:aws:iam::353981446712:role/rds-monitoring-role"
  performance_insights_enabled = "false"
  publicly_accessible          = false #VPC外からのアクセスを禁止
}
