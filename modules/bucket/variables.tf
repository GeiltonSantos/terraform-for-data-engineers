variable "name_bucket_script_glue_job" {
  type        = string
  description = "Nome do bucket principal para alocar os recursos do job glue"
}

variable "project_name" {
  type        = string
  description = "Nome do projeto"
}

variable "tags" {
  type        = map(any)
  description = "Tags comuns que serão usada em todo o projeto"

}