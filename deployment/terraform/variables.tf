variable "kubeconfig_path" {
  description = "Path to the kubeconfig file for the OpenShift cluster"
  type        = string
}

variable "namespace" {
  description = "The OpenShift namespace to deploy into"
  type        = string
  default     = "nlmontes777-dev"
}
