# output "db_rds_cluster_EndPoint" {
#   value = aws_rds_cluster.sbcntr_db.endpoint
# }

output "alb_ingress_frontend_tf_DnsName" {
  value = aws_lb.sbcntr_alb_ingress_frontend.dns_name
}

# output "alb_internal_tf_DnsName" {
#   value = aws_lb.sbcntr_alb_internal.dns_name
# }

# output "alb_ingress_frontend_tf_TargetGroupArn" {
#   value = aws_lb_listener.sbcntr_alb_ingress_frontend_80.default_action
# }

# output "alb_internal_tf_TargetGroupArn" {
#   value = aws_lb_listener.sbcntr_alb_internal_80.default_action
# }
