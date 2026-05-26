variable "location" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "westus"
}

variable "resource_group_name" {
  description = "Nome do Grupo de Recursos"
  type        = string
  default     = "rg-homelab-devops"
}

variable "vm_name" {
  description = "Nome da Máquina Virtual"
  type        = string
  default     = "vm-devops-lab"
}

variable "admin_username" {
  description = "Usuário administrador da VM"
  type        = string
  default     = "lucasadmin"
}

variable "ssh_public_key_path" {
  description = "Caminho para a chave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}