variable "resource_group_name" {
  type        = string
  description = "El grupo de recursos."
}

variable "location" {
  type        = string
  description = "La ubicación de los recursos"
}

variable "vmcount" {
  type        = number
  description = "Cuántas máquinas por crear"
}

variable "admin_username" {
  type        = string
  description = "Nombre del usuario"
}

variable "admin_password" {
  type        = string
  description = "Contraseña de acceso"
}