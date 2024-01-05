variable "project_name" {
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Tags comuns que serão usada em todo o projeto"

}