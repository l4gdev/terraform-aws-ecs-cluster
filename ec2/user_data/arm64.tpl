#!/bin/bash
echo ECS_CLUSTER=${cluster-name} >> /etc/ecs/ecs.config
### https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
yum install -y aws-cli jq
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_arm64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent