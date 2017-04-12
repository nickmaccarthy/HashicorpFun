
output "consul1_public_ip" {
  value = "${module.consul1.public_ip}"
}

output "consul2_public_ip" {
  value = "${module.consul2.public_ip}"
}

output "vault_public_ip" {
  value = "${module.vault.public_ip}"
}

output "appserver_public_ip" {
  value = "${module.appserver.public_ip}"
}
