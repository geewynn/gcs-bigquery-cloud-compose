# Outputs
output "us_bucket_name" {
  value = google_storage_bucket.us_bucket.name
}

output "eu_bucket_name" {
  value = google_storage_bucket.eu_bucket.name
}

output "bigquery_dataset_id" {
  value = google_bigquery_dataset.dataset.dataset_id
}

output "airflow_environment_name" {
  value = google_composer_environment.airflow.name
}

output "airflow_gcs_bucket" {
  value = split("/", data.google_composer_environment.airflow.config[0].dag_gcs_prefix)[2]
}