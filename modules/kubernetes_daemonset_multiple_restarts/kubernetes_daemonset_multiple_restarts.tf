resource "shoreline_notebook" "kubernetes_daemonset_multiple_restarts" {
  name       = "kubernetes_daemonset_multiple_restarts"
  data       = file("${path.module}/data/kubernetes_daemonset_multiple_restarts.json")
  depends_on = [shoreline_action.invoke_resource_usage_metrics,shoreline_action.invoke_change_container_limit]
}

resource "shoreline_file" "resource_usage_metrics" {
  name             = "resource_usage_metrics"
  input_file       = "${path.module}/data/resource_usage_metrics.sh"
  md5              = filemd5("${path.module}/data/resource_usage_metrics.sh")
  description      = "The Kubernetes cluster may not have enough resources to support the containers running on the Daemonset, causing them to restart frequently."
  destination_path = "/agent/scripts/resource_usage_metrics.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "change_container_limit" {
  name             = "change_container_limit"
  input_file       = "${path.module}/data/change_container_limit.sh"
  md5              = filemd5("${path.module}/data/change_container_limit.sh")
  description      = "Increase the resources allocated to the containers to prevent them from running out of memory or CPU and causing a restart."
  destination_path = "/agent/scripts/change_container_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_resource_usage_metrics" {
  name        = "invoke_resource_usage_metrics"
  description = "The Kubernetes cluster may not have enough resources to support the containers running on the Daemonset, causing them to restart frequently."
  command     = "`chmod +x /agent/scripts/resource_usage_metrics.sh && /agent/scripts/resource_usage_metrics.sh`"
  params      = ["DAEMONSET_NAME"]
  file_deps   = ["resource_usage_metrics"]
  enabled     = true
  depends_on  = [shoreline_file.resource_usage_metrics]
}

resource "shoreline_action" "invoke_change_container_limit" {
  name        = "invoke_change_container_limit"
  description = "Increase the resources allocated to the containers to prevent them from running out of memory or CPU and causing a restart."
  command     = "`chmod +x /agent/scripts/change_container_limit.sh && /agent/scripts/change_container_limit.sh`"
  params      = ["DAEMONSET_NAME","CONTAINER_NAME","NAMESPACE"]
  file_deps   = ["change_container_limit"]
  enabled     = true
  depends_on  = [shoreline_file.change_container_limit]
}

