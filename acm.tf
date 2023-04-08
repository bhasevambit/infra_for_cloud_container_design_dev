resource "aws_acm_certificate" "root" {
  domain_name = data.aws_route53_zone.this.name #「route53.tf」においてData Source定義した「data.aws_route53_zone.this」を使用

  validation_method = "DNS"

  tags = {
    Name = "sbcntr-acm-certification"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "root" {
  certificate_arn = aws_acm_certificate.root.arn #検証対象のACM証明書のARNを指定
}
