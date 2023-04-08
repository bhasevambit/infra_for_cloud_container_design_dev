#!/bin/zsh

#===== desired-countを0とした上で、ECSサービスを更新=====
aws ecs update-service --cluster sbcntr-ecs-frontend-cluster --service sbcntr-ecs-frontend-service --desired-count 1
aws ecs update-service --cluster sbcntr-ecs-backend-cluster --service sbcntr-ecs-backend-service --desired-count 1

#===== ECS AutoScaleの一時停止の解除 =====
aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension "ecs:service:DesiredCount" \
  --resource-id "service/sbcntr-ecs-frontend-cluster/sbcntr-ecs-frontend-service" \
  --suspended-state DynamicScalingOutSuspended=false

aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension "ecs:service:DesiredCount" \
  --resource-id "service/sbcntr-ecs-backend-cluster/sbcntr-ecs-backend-service" \
  --suspended-state DynamicScalingOutSuspended=false
