#!/bin/bash
echo ECS_CLUSTER=${cluster-name} >> /etc/ecs/ecs.config
### https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html
echo ECS_ENABLE_TASK_IAM_ROLE=true >> /etc/ecs/ecs.config
yum install -y aws-cli jq
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent

%{if fsx != null}
yum install -y nfs-utils
%{endif}

%{ for name, config in fsx }
mkdir -p ${config.configuration.mount_path}
mount -t nfs -o nfsvers=4.1 ${config.dns_name}:/fsx ${config.configuration.mount_path}
%{ endfor ~}
