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

variable "nome_bucket" {
  type        = string
  description = "Nome do bucket para leitura do script python"
}

variable "arn_role" {
  type        = string
  description = "arn da role que sera assinada pelo glue para que o job consiga executar as tarefas"
}