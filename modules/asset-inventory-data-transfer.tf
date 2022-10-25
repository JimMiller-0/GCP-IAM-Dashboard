ata "google_project" "project" {
}

resource "google_project_iam_member" "permissions" {
  project = data.google_project.project.project_id
  role   = "roles/iam.serviceAccountShortTermTokenMinter"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}

resource "google_bigquery_data_transfer_config" "query_config" {
  depends_on = [google_project_iam_member.permissions]

  display_name           = "my-query"
  location               = "asia-northeast1"
  data_source_id         = "scheduled_query"
  schedule               = "first sunday of quarter 00:00"
  destination_dataset_id = google_bigquery_dataset.my_dataset.dataset_id
  params = {
    destination_table_name_template = "my_table"
    write_disposition               = "WRITE_APPEND"
    query                           = "SELECT name FROM tabl WHERE x = 'y'"
  }
}

resource "google_bigquery_dataset" "my_dataset" {
  depends_on = [google_project_iam_member.permissions]

  dataset_id    = "my_dataset"
  friendly_name = "foo"
  description   = "bar"
  location      = "asia-northeast1"
}