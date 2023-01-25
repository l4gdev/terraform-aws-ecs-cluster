variable "datadog" {
  type = object({
    api_key_secret_manager_name = string
    site                        = optional(string, "datadoghq.eu")
    process_agent_enabled       = optional(bool, true)
    logs_enable                 = optional(bool, true),
    collect_all_logs            = optional(bool, false)
    apm_enable                  = optional(bool, false),
    agent_log_level             = optional(string, "ERROR")
  })
  description = "please set api key as DD_API_KEY"
}

variable "ecs_cluster_name" {
  type = string
}
