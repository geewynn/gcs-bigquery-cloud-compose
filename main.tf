# Create US bucket
resource "google_storage_bucket" "us_bucket" {
  name     = "${var.bucket_name}-us"
  location = "US"
}

# Create EU bucket
resource "google_storage_bucket" "eu_bucket" {
  name     = "${var.bucket_name}-eu"
  location = "EU"
}

# Create BigQuery dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.dataset_id
  location   = var.region
}

# Create Cloud Composer environment (Airflow)
resource "google_composer_environment" "airflow" {
  name   = var.airflow_name
  region = var.region

  config {
    node_config {
      zone = var.zone
    }

    software_config {
      image_version = "composer-3-airflow-2.9.1-build.6"

      env_variables = {
        table_list_file_path = "/home/airflow/gcs/dags/bq_copy_eu_to_us_sample.csv"
        gcs_source_bucket  = google_storage_bucket.us_bucket.name
        gcs_dest_bucket  = google_storage_bucket.eu_bucket.name
      }
    }
  }
}


# Get the GCS bucket associated with the Composer environment
data "google_composer_environment" "airflow" {
  name    = google_composer_environment.airflow.name
  region  = var.region
  project = var.project_id
}

# Upload DAG files to the Composer environment
resource "google_storage_bucket_object" "dags" {
  for_each = fileset(var.dags_folder, "**/*.py")

  name   = "dags/${each.value}"
  source = "${var.dags_folder}/${each.value}"
  bucket = split("/", data.google_composer_environment.airflow.config[0].dag_gcs_prefix)[2]
}

# Upload plugin files to the Composer environment
resource "google_storage_bucket_object" "plugins" {
  for_each = fileset(var.plugins_folder, "**/*")

  name   = "plugins/${each.value}"
  source = "${var.plugins_folder}/${each.value}"
  bucket = split("/", data.google_composer_environment.airflow.config[0].dag_gcs_prefix)[2]
}
