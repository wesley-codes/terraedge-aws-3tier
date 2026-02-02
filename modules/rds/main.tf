resource "aws_db_subnet_group" "terraedge_rds" {
  name       = "terraedge-db-subnet-group"
  subnet_ids = [var.private_subnetID_1, var.private_subnetID_2]

  tags = {
    Name = "terraedge-rds-subnet-group"
  }
}

data "aws_subnet" "writer_subnet" {
  id = var.private_subnetID_1
}

data "aws_subnet" "reader_subnet" {
  id = var.private_subnetID_2
}

resource "aws_db_instance" "writer" {
  identifier                = "terraedge-writer"
  engine                    = "postgres"
  instance_class            = "db.t3.micro"
  allocated_storage         = 20
  storage_type              = "gp3"
  storage_encrypted         = true
  db_subnet_group_name      = aws_db_subnet_group.terraedge_rds.name
  vpc_security_group_ids    = var.vpc_security_group_ids
  username                  = var.db_username
  password                  = var.db_passwd
  multi_az                  = false
  availability_zone         = data.aws_subnet.writer_subnet.availability_zone
  publicly_accessible       = false
  backup_retention_period   = 7
  skip_final_snapshot       = true
  final_snapshot_identifier = null
  


}


resource "aws_db_instance" "reader" {
  identifier             = "terraedge-reader"
  instance_class         = "db.t3.micro"
  replicate_source_db    = aws_db_instance.writer.arn
  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = aws_db_subnet_group.terraedge_rds.name
  availability_zone    = data.aws_subnet.reader_subnet.availability_zone
  publicly_accessible  = false

  skip_final_snapshot       = true
  final_snapshot_identifier = null
}
