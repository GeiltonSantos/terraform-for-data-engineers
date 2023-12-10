resource "aws_s3_bucket" "terraform_for_data_engineer_s3" {
  bucket = var.name_bucket_script_glue_job

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "upload_arquivos" {
  bucket = aws_s3_bucket.terraform_for_data_engineer_s3.id

  for_each = fileset("app/src", "**/*.*")

  key          = each.value
  source       = "app/src/${each.value}"
  content_type = each.value
}