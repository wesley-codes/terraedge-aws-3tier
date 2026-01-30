output "writer_info" {
  description = "Writer RDS instance identifiers and AZ"
  value = {
    id         = aws_db_instance.writer.id
    identifier = aws_db_instance.writer.identifier
    az         = aws_db_instance.writer.availability_zone
  }
}

output "reader_info" {
  description = "Reader RDS instance identifiers and AZ"
  value = {
    id         = aws_db_instance.reader.id
    identifier = aws_db_instance.reader.identifier
    az         = aws_db_instance.reader.availability_zone
  }
}

output "writer_subnet_info" {
  description = "Writer subnet id and AZ"
  value = {
    id = data.aws_subnet.writer_subnet.id
    az = data.aws_subnet.writer_subnet.availability_zone
  }
}

output "reader_subnet_info" {
  description = "Reader subnet id and AZ"
  value = {
    id = data.aws_subnet.reader_subnet.id
    az = data.aws_subnet.reader_subnet.availability_zone
  }
}
