#!/bin/zsh

# --- Terraform Resources Activation ---
FRONTEND_TARGET_GROUP=`aws ecs describe-services --cluster sbcntr-ecs-frontend-cluster --services sbcntr-ecs-frontend-service | jq ".services[].loadBalancers[].targetGroupArn" | awk -F "/" '{print $2}' | awk -F "-" '{print $4}'`
BACKEND_TARGET_GROUP=`aws ecs describe-services --cluster sbcntr-ecs-backend-cluster --services sbcntr-ecs-backend-service | jq ".services[].loadBalancers[].targetGroupArn" | awk -F "/" '{print $2}' | awk -F "-" '{print $4}'`

echo ${FRONTEND_TARGET_GROUP}
echo ${BACKEND_TARGET_GROUP}

terraform apply -var="frontend_tg=${FRONTEND_TARGET_GROUP}" -var="backend_tg=${BACKEND_TARGET_GROUP}" -auto-approve

sleep 2

# --- CodeDeploy Activation ---
cd ./Activation_Scripts
./CodeDeploy_update_Load_Balancer_Listener.sh

cd ..
sleep 2

# --- ECS Activation ---
./Activation_Scripts/ECS_change_desiredCount_to_One.sh > /dev/null

sleep 2
