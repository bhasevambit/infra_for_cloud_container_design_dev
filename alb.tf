resource "aws_lb" "sbcntr_alb_ingress_frontend" {
  name = "sbcntr-alb-ingress-frontend-tf"

  internal                   = "false" #インターネットに接するALBであるため、「false」とする
  load_balancer_type         = "application"
  security_groups            = ["sg-0735c27c4170e404b"]
  subnets                    = ["subnet-070dd330ab54788b0", "subnet-07ba6c36eaea0de80"]
  enable_deletion_protection = "false" #Terraformによる一括destroyでの削除を可能とするため、「false」とする

  desync_mitigation_mode           = "defensive"
  drop_invalid_header_fields       = "false"
  enable_cross_zone_load_balancing = "true"
  enable_http2                     = "true"
  #enable_tls_version_and_cipher_suite_headers = "false"
  enable_waf_fail_open = "false"
  #enable_xff_client_port                      = "false"
  idle_timeout         = "60"
  ip_address_type      = "ipv4"
  preserve_host_header = "false"
  #xff_header_processing_mode                  = "append"
}

resource "aws_lb" "sbcntr_alb_internal" {
  name = "sbcntr-alb-internal-tf"

  internal                   = "true" #バックエンドアプリケーションコンテナの直前に位置するALBである事から、「true」とする
  load_balancer_type         = "application"
  security_groups            = ["sg-03933dd276e130fe4"]
  subnets                    = ["subnet-0b15f3789eff8ef18", "subnet-0b8c7c13b6929303e"]
  enable_deletion_protection = "false" #Terraformによる一括destroyでの削除を可能とするため、「false」とする

  desync_mitigation_mode           = "defensive"
  drop_invalid_header_fields       = "false"
  enable_cross_zone_load_balancing = "true"
  enable_http2                     = "true"
  #enable_tls_version_and_cipher_suite_headers = "false"
  enable_waf_fail_open = "false"
  #enable_xff_client_port                      = "false"
  idle_timeout         = "60"
  ip_address_type      = "ipv4"
  preserve_host_header = "false"
  #xff_header_processing_mode                  = "append"
}


locals {
  tg_frontend_blue_arn  = "arn:aws:elasticloadbalancing:ap-northeast-1:353981446712:targetgroup/sbcntr-tg-frontend-blue/2c12ab2ec3952cba"
  tg_frontend_green_arn = "arn:aws:elasticloadbalancing:ap-northeast-1:353981446712:targetgroup/sbcntr-tg-frontend-green/c92022f889c1185b"
  tg_backend_blue_arn   = "arn:aws:elasticloadbalancing:ap-northeast-1:353981446712:targetgroup/sbcntr-tg-backend-blue/a4d3d8d2477a904b"
  tg_backend_green_arn  = "arn:aws:elasticloadbalancing:ap-northeast-1:353981446712:targetgroup/sbcntr-tg-backend-green/edf878b4e5efe66a"
}

# --- Ingress Frontend ALB向け本番リスナー(port:443) ---
resource "aws_lb_listener" "sbcntr_alb_ingress_frontend_443" {
  certificate_arn   = aws_acm_certificate.root.arn
  load_balancer_arn = aws_lb.sbcntr_alb_ingress_frontend.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    order            = "1"
    target_group_arn = var.frontend_tg == "green" ? local.tg_frontend_green_arn : local.tg_frontend_blue_arn #CodeDeployにおけるBlue/Green Deployの最新状況に合わせたターゲットグループ割当て
  }
}

# --- Ingress Frontend ALB向けテストリスナー(port:10080) ---
resource "aws_lb_listener" "sbcntr_alb_ingress_frontend_10080" {
  load_balancer_arn = aws_lb.sbcntr_alb_ingress_frontend.id
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    order            = "1"
    target_group_arn = var.frontend_tg == "green" ? local.tg_frontend_green_arn : local.tg_frontend_blue_arn #CodeDeployにおけるBlue/Green Deployの最新状況に合わせたターゲットグループ割当て
  }
}

# --- Internal ALB向け本番リスナー(port:80) ---
resource "aws_lb_listener" "sbcntr_alb_internal_80" {
  load_balancer_arn = aws_lb.sbcntr_alb_internal.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    order            = "1"
    target_group_arn = var.backend_tg == "green" ? local.tg_backend_green_arn : local.tg_backend_blue_arn
  }
}

# --- Internal ALB向けテストリスナー(port:10080) ---
resource "aws_lb_listener" "sbcntr_alb_internal_10080" {
  load_balancer_arn = aws_lb.sbcntr_alb_internal.id
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    order            = "1"
    target_group_arn = var.backend_tg == "green" ? local.tg_backend_green_arn : local.tg_backend_blue_arn
  }
}
