# Variables
variable "project_id" {
  description = "Google Cloud Project ID"
}

variable "region" {
  description = "Default region for resources"
  default     = "us-central1"
}

variable "zone" {
  description = "Default zone for resources"
  default     = "us-central1-a"
}

variable "bucket_name" {
  description = "Base name for buckets"
}

variable "dataset_id" {
  description = "BigQuery dataset ID"
}

variable "airflow_name" {
  description = "Name for the Airflow environment"
}

variable "dags_folder" {
  description = "Local folder containing DAG files"
  default     = "./dags"
}

variable "plugins_folder" {
  description = "Local folder containing plugin files"
  default     = "./plugins"
}