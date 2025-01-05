output "node_url" {
  value       = "https://${local.address}:8006/"
  description = "Web URL of the PVE manager."
}

output "password" {
  value       = local.use_generated_password ? random_password.root[0].result : ""
  description = "Generated initial root password. Empty if password hash was supplied as input."
  sensitive   = true
}
