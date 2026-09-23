output "operating_regions" {
  description = "All IPAM operating Regions. Includes the two registered via additional_operating_regions even though no pool uses them."
  value       = module.basic.operating_regions
}

output "ipam_info" {
  description = "Basic IPAM info."
  value       = module.basic.ipam_info
}
