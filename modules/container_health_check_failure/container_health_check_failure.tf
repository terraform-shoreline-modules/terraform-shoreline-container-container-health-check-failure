resource "shoreline_notebook" "container_health_check_failure" {
  name       = "container_health_check_failure"
  data       = file("${path.module}/data/container_health_check_failure.json")
  depends_on = [shoreline_action.invoke_check_container_health,shoreline_action.invoke_health_check_restart_container,shoreline_action.invoke_container_resource_check]
}

resource "shoreline_file" "check_container_health" {
  name             = "check_container_health"
  input_file       = "${path.module}/data/check_container_health.sh"
  md5              = filemd5("${path.module}/data/check_container_health.sh")
  description      = "Check if the container is running and the health check is enabled."
  destination_path = "/tmp/check_container_health.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "health_check_restart_container" {
  name             = "health_check_restart_container"
  input_file       = "${path.module}/data/health_check_restart_container.sh"
  md5              = filemd5("${path.module}/data/health_check_restart_container.sh")
  description      = "Check if the health check endpoint is returning the expected response status code."
  destination_path = "/tmp/health_check_restart_container.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "container_resource_check" {
  name             = "container_resource_check"
  input_file       = "${path.module}/data/container_resource_check.sh"
  md5              = filemd5("${path.module}/data/container_resource_check.sh")
  description      = "Check if the container is running out of resources like CPU, memory, or I/O, causing the health check to fail."
  destination_path = "/tmp/container_resource_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_container_health" {
  name        = "invoke_check_container_health"
  description = "Check if the container is running and the health check is enabled."
  command     = "`chmod +x /tmp/check_container_health.sh && /tmp/check_container_health.sh`"
  params      = ["CONTAINER_NAME"]
  file_deps   = ["check_container_health"]
  enabled     = true
  depends_on  = [shoreline_file.check_container_health]
}

resource "shoreline_action" "invoke_health_check_restart_container" {
  name        = "invoke_health_check_restart_container"
  description = "Check if the health check endpoint is returning the expected response status code."
  command     = "`chmod +x /tmp/health_check_restart_container.sh && /tmp/health_check_restart_container.sh`"
  params      = ["EXPECTED_STATUS_CODE","CONTAINER_NAME","HEALTH_CHECK_ENDPOINT"]
  file_deps   = ["health_check_restart_container"]
  enabled     = true
  depends_on  = [shoreline_file.health_check_restart_container]
}

resource "shoreline_action" "invoke_container_resource_check" {
  name        = "invoke_container_resource_check"
  description = "Check if the container is running out of resources like CPU, memory, or I/O, causing the health check to fail."
  command     = "`chmod +x /tmp/container_resource_check.sh && /tmp/container_resource_check.sh`"
  params      = ["CPU_THRESHOLD","CONTAINER_NAME","MEM_THRESHOLD","IO_THRESHOLD"]
  file_deps   = ["container_resource_check"]
  enabled     = true
  depends_on  = [shoreline_file.container_resource_check]
}

