terraform {
  required_providers {
    guance = {
      source  = "GuanceCloud/guance"
      version = "~> 0.0.4"
    }
  }
}

provider "guance" {}

# create guance pipeline
resource "guance_pipeline" "ruoyi-log" {
  name     = "ruoyi-log"
  category = "logging"
  source = [
    "ruoyi-mysql"
  ]
  is_default = false
  is_force   = false

  content = <<EOF
  grok(_, "%%{TIMESTAMP_ISO8601:time} %%{NOTSPACE:thread_name} %%{LOGLEVEL:status}%%{SPACE}%%{NOTSPACE:class_name} - \\[%%{NOTSPACE:method_name},%%{NUMBER:line}\\] - %%{DATA:service} %%{DATA:trace_id} %%{DATA:span_id} - %%{GREEDYDATA:msg}")
  default_time(time, "Asia/Shanghai")
  EOF
}

resource "guance_pipeline" "ruoyi-nginx" {
  name     = "ruoyi-nginx"
  category = "logging"
  source = [
    "ruoyi-nginx"
  ]
  is_default = false
  is_force   = false

  content = <<EOF
  json(_, opentracing_context_x_datadog_trace_id, trace_id)
  json(_, `@timestamp`, time)
  json(_, status)
  group_between(status, [200, 300], "OK")
  default_time(time)
  EOF
}

resource "guance_blacklist" "ruoyi-blacklist" {
  source = {
    type = "rum"
    name = "ruoyi_web"
  }

  filter_rules = [
    {
      name      = "resource_url_path"
      operation = "match"
      condition = "and"
      values    = ["/rum/*"]
    }
  ]
}
