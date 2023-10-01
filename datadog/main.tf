locals {
  datadog_configuration = {
    "name" : "datadog-agent",
    "image" : "datadog/agent:latest",
    "cpu" : 10,
    "memory" : 256,
    "essential" : true,
    "portMappings" : [
      {
        "hostPort" : 8125,
        "protocol" : "udp",
        "containerPort" : 8125
      },
      {
        "hostPort" : 8126,
        "protocol" : "tcp",
        "containerPort" : 8126
      }
    ],
    "mountPoints" : [
      {
        "readOnly" : true,
        "containerPath" : "/var/run/docker.sock",
        "sourceVolume" : "docker_sock"
      },
      {
        "readOnly" : true,
        "containerPath" : "/host/sys/fs/cgroup",
        "sourceVolume" : "cgroup"
      },
      {
        "readOnly" : true,
        "containerPath" : "/host/proc",
        "sourceVolume" : "proc"
      },
      {
        "readOnly" : true,
        "containerPath" : "/etc/passwd",
        "sourceVolume" : "passwd"
      }
    ],
    "environment" : [
      {
        "name" : "DD_API_KEY",
        "valueFrom" : "${data.aws_secretsmanager_secret_version.dd_api_key.arn}::DD_API_KEY"
      },
      {
        "name" : "DD_SITE",
        "value" : var.datadog.site
      },
      {
        "name" : "DD_PROCESS_AGENT_ENABLED",
        "value" : tostring(var.datadog.process_agent_enabled)
      },
      {
        "name" : "DD_APM_ENABLED",
        "value" : tostring(var.datadog.apm_enable)
      },
      {
        "name" : "DD_LOGS_ENABLED",
        "value" : tostring(var.datadog.logs_enable)
      },
      {
        "name" : "DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL",
        "value" : tostring(var.datadog.collect_all_logs)
      },
      {
        "name" : "DD_DOGSTATSD_NON_LOCAL_TRAFFIC",
        "value" : "true"
      },
      {
        "name" : "DD_LOG_LEVEL",
        "value" : var.datadog.agent_log_level
      }
    ],
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "datadog-agent-task"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = jsonencode(local.datadog_configuration)

  volume {
    name      = "docker_sock"
    host_path = "/var/run/docker.sock"
  }
  volume {
    name      = "proc"
    host_path = "/proc/"
  }
  volume {
    name      = "cgroup"
    host_path = "/sys/fs/cgroup/"
  }
  volume {
    name      = "passwd"
    host_path = "/etc/passwd"
  }
}

resource "aws_ecs_service" "service" {
  name = "datadog-agent"

  cluster             = var.ecs_cluster_name
  task_definition     = aws_ecs_task_definition.service.id
  launch_type         = "EC2"
  scheduling_strategy = "DAEMON"
}
