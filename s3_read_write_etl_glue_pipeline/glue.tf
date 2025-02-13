resource "aws_glue_job" "glue_job" {
  name              = "glue-job"
  role_arn          = aws_iam_role.glue_service_role.arn
  description       = "Transfer csv from source to bucket"
  glue_version      = "4.0"
  worker_type       = "G.1X"
  timeout           = 2880
  max_retries       = 1
  number_of_workers = 2
  command {
    name            = "glueetl"
    python_version  = 3
    script_location = "s3://${aws_s3_bucket.dc-caco-code-bucket.id}/script.py"
  }

  default_arguments = {
    "--enable-auto-scaling"             = "true"
    "--enable-continous-cloudwatch-log" = "true"
    "--datalake-formats"                = "delta"
    "--source-path"                     = "s3://${aws_s3_bucket.dc-caco-source-data-bucket.id}/"
    "--destination-path"                = "s3://${aws_s3_bucket.dc-caco-target-data-bucket.id}/"
    "--job-name"                        = "glue-job"
    "--enable-continuous-log-filter"    = "true"
    "--enable-metrics"                  = "true"
  }
}

resource "aws_glue_trigger" "org_report_trigger" {
  name = "org-report-trigger"
  type = "ON_DEMAND"
  # Disable running automatically after apply.
  #   See: https://github.com/hashicorp/terraform-provider-aws/issues/38222
  enabled = false  

  actions {
    crawler_name = aws_glue_crawler.org_report_crawler.name
  }
}

resource "aws_glue_crawler" "org_report_crawler" {
  name          = "org-report-crawler"
  database_name = aws_glue_catalog_database.org_report_database.name
  role          = aws_iam_role.glue_service_role.name
  s3_target {
    path = "${aws_s3_bucket.dc-caco-source-data-bucket.id}/"
  }
  schema_change_policy {
    delete_behavior = "LOG"
  }
  configuration = jsonencode({
    "Version" = 1.0
    "Grouping" = {
      "TableGroupingPolicy" = "CombineCompatibleSchemas"
    }
  })
}

resource "aws_glue_catalog_database" "org_report_database" {
  name         = "org-report"
  location_uri = "${aws_s3_bucket.dc-caco-source-data-bucket.id}/"
}

output "glue_crawler_name" {
  value = "s3//${aws_s3_bucket.dc-caco-source-data-bucket.id}/"
}
