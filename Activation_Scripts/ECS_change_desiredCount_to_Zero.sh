#!/bin/zsh

#===== ECS AutoScaleの一時停止 =====
aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension "ecs:service:DesiredCount" \
  --resource-id "service/sbcntr-ecs-frontend-cluster/sbcntr-ecs-frontend-service" \
  --suspended-state DynamicScalingOutSuspended=true

aws application-autoscaling register-scalable-target \
  --service-namespace ecs \
  --scalable-dimension "ecs:service:DesiredCount" \
  --resource-id "service/sbcntr-ecs-backend-cluster/sbcntr-ecs-backend-service" \
  --suspended-state DynamicScalingOutSuspended=true

#===== desired-countを0とした上で、ECSサービスを更新=====
aws ecs update-service --cluster sbcntr-ecs-frontend-cluster --service sbcntr-ecs-frontend-service --desired-count 0
aws ecs update-service --cluster sbcntr-ecs-backend-cluster --service sbcntr-ecs-backend-service --desired-count 0
