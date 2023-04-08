#!/bin/zsh

#===== ロードバランサーARNの取得 =====
FRONTEND_ALB_ARN=`aws elbv2 describe-load-balancers --names sbcntr-alb-ingress-frontend-tf | jq ".LoadBalancers[].LoadBalancerArn" | sed -e 's/"//g'`
BACKEND_ALB_ARN=`aws elbv2 describe-load-balancers --names sbcntr-alb-internal-tf | jq ".LoadBalancers[].LoadBalancerArn" | sed -e 's/"//g'`


#===== ロードバランサーリスナーARNの取得 =====
#--- Port:443がIngress Frontend ALBの本番リスナー---
FRONTEND_PROD_LISTNER=`aws elbv2 describe-listeners --load-balancer-arn ${FRONTEND_ALB_ARN} | jq ".Listeners[] | select(.Port == 443).ListenerArn" | sed -e 's/"//g'`
#--- Port:10080がIngress Frontend ALBのテストリスナー ---
FRONTEND_TEST_LISTNER=`aws elbv2 describe-listeners --load-balancer-arn ${FRONTEND_ALB_ARN} | jq ".Listeners[] | select(.Port == 10080).ListenerArn" | sed -e 's/"//g'`

#--- Port:80がInternal ALBの本番リスナー---
BACKEND_PROD_LISTNER=`aws elbv2 describe-listeners --load-balancer-arn ${BACKEND_ALB_ARN} | jq ".Listeners[] | select(.Port == 80).ListenerArn" | sed -e 's/"//g'`
#--- Port:10080がInternal ALBのテストリスナー ---
BACKEND_TEST_LISTNER=`aws elbv2 describe-listeners --load-balancer-arn ${BACKEND_ALB_ARN} | jq ".Listeners[] | select(.Port == 10080).ListenerArn" | sed -e 's/"//g'`

echo ${FRONTEND_PROD_LISTNER}
echo ${FRONTEND_TEST_LISTNER}
echo ${BACKEND_PROD_LISTNER}
echo ${BACKEND_TEST_LISTNER}


#===== Frontend向けjsonファイルのロードバランサーリスナーARNの書き換え =====
cat ./CodeDeploy_deploymnet-group_load-balancer-info_frontend-template.json | \
    jq '.loadBalancerInfo.targetGroupPairInfoList[].prodTrafficRoute.listenerArns|=["'${FRONTEND_PROD_LISTNER}'"]' | \
    jq '.loadBalancerInfo.targetGroupPairInfoList[].testTrafficRoute.listenerArns|=["'${FRONTEND_TEST_LISTNER}'"]' \
    > CodeDeploy_deploymnet-group_load-balancer-info_frontend.json


#===== Backend向けjsonファイルのロードバランサーリスナーARNの書き換え =====
cat ./CodeDeploy_deploymnet-group_load-balancer-info_backend-template.json | \
    jq '.loadBalancerInfo.targetGroupPairInfoList[].prodTrafficRoute.listenerArns|=["'${BACKEND_PROD_LISTNER}'"]' | \
    jq '.loadBalancerInfo.targetGroupPairInfoList[].testTrafficRoute.listenerArns|=["'${BACKEND_TEST_LISTNER}'"]' \
    > CodeDeploy_deploymnet-group_load-balancer-info_backend.json


#===== Frontend向けCode Deploy デプロイグループのロードバランサーリスナーの設定変更 =====
aws deploy update-deployment-group --cli-input-json file://CodeDeploy_deploymnet-group_load-balancer-info_frontend.json


#===== Backend向けCode Deploy デプロイグループのロードバランサーリスナーの設定変更 =====
aws deploy update-deployment-group --cli-input-json file://CodeDeploy_deploymnet-group_load-balancer-info_backend.json
