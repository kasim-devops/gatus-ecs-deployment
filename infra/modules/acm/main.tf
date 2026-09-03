# Look up existing route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name         = var.route53_zone_name
  private_zone = false
}

# ACM Certificate
resource "aws_acm_certificate" "app-cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
# Create DNS validation records
resource "aws_route53_record" "app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.app-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}
# Wait for DNS validation to complete
resource "aws_acm_certificate_validation" "app_cert" {
  certificate_arn         = aws_acm_certificate.app-cert.arn
  validation_record_fqdns = [for record in aws_route53_record.app_cert_validation : record.fqdn]
}