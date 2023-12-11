output "bucket_name" {
  value = module.terraform_for_data_engineers_bucket.bucket_name
}

output "arn_role" {
  value = module.terraform_for_data_engineers_iam.arn_role
}