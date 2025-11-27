output "ec2_public_ip" {
  value = module.ec2_module.instance_public_ip
}

output "ec2_public_dns" {
  value = module.ec2_module.instance_public_dns
}