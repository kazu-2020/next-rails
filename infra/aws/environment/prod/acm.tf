resource "aws_acm_certificate" "cert" {
  domain_name               = "zoutrendy.site"
  subject_alternative_names = ["*.zoutrendy.site"]

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_main : record.fqdn]
}
