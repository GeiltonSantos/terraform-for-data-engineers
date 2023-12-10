resource "aws_glue_job" "terraform_for_data_engineer_glue_job" {
  name     = var.project_name
  role_arn = aws_iam_role.terraform_for_data_engineer_role.arn

  command {
    script_location = "s3://${aws_s3_bucket.terraform_for_data_engineer_s3.bucket}/terraform_for_data_engineer.py"
  }
  description       = "Job Teste Terraform for data engineer"
  glue_version      = "4.0"
  timeout           = 20
  worker_type       = "G.1X"
  number_of_workers = 3
  default_arguments = {
    "--key" = "value"
  }
  tags = local.tags
}