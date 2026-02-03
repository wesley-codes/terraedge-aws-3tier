resource "aws_acm_certificate" "terraedge_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = [var.domain_name, "www.${var.domain_name}"]

  tags = {
    Environment = "terraedge"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_acm_certificate_validation" "terraedge_cert_validation" {
  certificate_arn         = aws_acm_certificate.terraedge_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
