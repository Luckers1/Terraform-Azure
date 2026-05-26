output "public_ip_address" {
  description = "IP Público da VM criada"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_id" {
  description = "ID da Máquina Virtual"
  value       = azurerm_linux_virtual_machine.vm.id
}