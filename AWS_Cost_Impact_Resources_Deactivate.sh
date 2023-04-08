#!/bin/zsh

# --- Terraform Resources Deactivation ---
terraform destroy -auto-approve

sleep 2

# --- ECS Deactivation ---
./Activation_Scripts/ECS_change_desiredCount_to_Zero.sh > /dev/null

sleep 2

# --- EC2 for Cloud9 Deactivation ---
aws ec2 stop-instances --instance-ids i-089897f342f597aa6

sleep 2