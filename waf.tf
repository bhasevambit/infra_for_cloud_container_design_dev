resource "aws_wafv2_web_acl" "sbcntr_waf_webacl_tf" {
  name        = "sbcntr-waf-webacl-tf"
  description = "Web Application Firewall for sbcntr"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 4

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "sbcntr-waf-webacl-tf"
    sampled_requests_enabled   = true
  }

  tags = {
    name = "sbcntr-waf-webacl-tf"
  }
}

# --- Web ACLとALBの紐付け ---
resource "aws_wafv2_web_acl_association" "sbcntr_waf_webacl_tf" {
  resource_arn = aws_lb.sbcntr_alb_ingress_frontend.arn #Ingress Frontend ALBのARNをセット
  web_acl_arn  = aws_wafv2_web_acl.sbcntr_waf_webacl_tf.arn #上記にて作成したWeb ACLのARNをセット
}
