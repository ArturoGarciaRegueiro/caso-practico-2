variable "location" {
  type = string
  description = "Región de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

variable "vm_size" {
  type = string
  description = "Tamaño de la máquina virtual"
  default = "Standard_D1_v2" # 4 GB, 2 CPU 
}

variable "master_size" {
  type = string
  description = "Tamaño de la máquina virtual"
  default = "Standard_DS2_v2" # 8 GB, 2 CPU 
}

variable "vms" {
  description = "Máquinas virtuales que se crean"
  type = list(string)
  default = ["master", "nfs","worker01", "worker02"]
}