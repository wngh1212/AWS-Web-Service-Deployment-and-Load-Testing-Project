resource "grafana_rule_group" "rule_group_47349c2ce5ed941e" {
  org_id           = 1
  name             = "status"
  folder_uid       = "ceqstgsjbbabka"
  interval_seconds = 30

  rule {
    name      = "use memory"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "eeq3l7lyzo2yoa"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100) > 80\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "메모리 사용량 이상"
    }
    is_paused = false

    notification_settings {
      contact_point = "discord-bot"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "use CPU"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "eeq3l7lyzo2yoa"
      model          = "{\"editorMode\":\"code\",\"expr\":\"100 - avg(irate(node_cpu_seconds_total{mode=\\\"idle\\\"}[5m])) * 100 > 80\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "30s"
    annotations = {
      description = "CPU 사용량 이상"
    }
    is_paused = false

    notification_settings {
      contact_point = "discord-bot"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "root DISK"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "eeq3l7lyzo2yoa"
      model          = "{\"editorMode\":\"code\",\"expr\":\"(node_filesystem_size_bytes{mountpoint=\\\"/\\\"} - node_filesystem_free_bytes{mountpoint=\\\"/\\\"}) / node_filesystem_size_bytes{mountpoint=\\\"/\\\"} * 100 > 80\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "disk 사용량 조절 필요"
    }
    is_paused = false

    notification_settings {
      contact_point = "discord-bot"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "Process"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "eeq3l7lyzo2yoa"
      model          = "{\"editorMode\":\"code\",\"expr\":\"node_procs_running > 300\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "프로세스 점유 이상"
    }
    is_paused = false

    notification_settings {
      contact_point = "discord-bot"
      group_by      = null
      mute_timings  = null
    }
  }
  rule {
    name      = "reboot check"
    condition = "C"

    data {
      ref_id = "A"

      relative_time_range {
        from = 600
        to   = 0
      }

      datasource_uid = "eeq3l7lyzo2yoa"
      model          = "{\"editorMode\":\"code\",\"expr\":\"time() - node_boot_time_seconds < 300\",\"instant\":true,\"intervalMs\":1000,\"legendFormat\":\"__auto\",\"maxDataPoints\":43200,\"range\":false,\"refId\":\"A\"}"
    }
    data {
      ref_id = "C"

      relative_time_range {
        from = 0
        to   = 0
      }

      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }

    no_data_state  = "OK"
    exec_err_state = "Error"
    for            = "1m"
    annotations = {
      description = "5분 이내에 재부팅 되었음"
    }
    is_paused = false

    notification_settings {
      contact_point = "discord-bot"
      group_by      = null
      mute_timings  = null
    }
  }
}
