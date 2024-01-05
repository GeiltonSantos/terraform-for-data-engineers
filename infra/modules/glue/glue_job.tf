resource "aws_glue_job" "terraform_for_data_engineer_glue_job" {
  name     = var.project_name
  role_arn = var.arn_role

  command {
    script_location = "s3://${var.nome_bucket}/${var.project_name}.py"
  }
  description       = "Job Teste Terraform for data engineer"
  glue_version      = "4.0"
  timeout           = 20
  worker_type       = "G.1X"
  number_of_workers = 3
  default_arguments = {
    "--key" = "value"
  }
  tags = var.tags
}

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = var.project_name
  tags = var.tags
}