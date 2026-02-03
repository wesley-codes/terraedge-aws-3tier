resource "aws_wafv2_web_acl" "terraedge_waf" {
  name        = "terraedge-waf"
  description = "WAF for TerraEdge"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "terraedge-rule"
    priority = 0

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_QUERYSTRING"
        }

        rule_action_override {
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }

      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

 
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "BlockIPRuleMetric"
    sampled_requests_enabled   = false
  }
}