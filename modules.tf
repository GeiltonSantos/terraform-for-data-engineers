module "terraform_for_data_engineers_network" {
  source       = "./modules/network"
  project_name = var.project_name
  tags         = local.tags
}

module "terraform_for_data_engineers_iam" {
  source = "./modules/iam"
}

module "terraform_for_data_engineers_bucket" {
  source                      = "./modules/bucket"
  project_name                = var.project_name
  name_bucket_script_glue_job = var.name_bucket_script_glue_job
  tags                        = local.tags
}

module "terraform_for_data_engineers_glue" {
  source                      = "./modules/glue"
  name_bucket_script_glue_job = var.name_bucket_script_glue_job
  project_name                = var.project_name
  tags                        = local.tags
  nome_bucket                 = module.terraform_for_data_engineers_bucket.bucket_name
  arn_role                    = module.terraform_for_data_engineers_iam.arn_role
}