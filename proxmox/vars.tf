variable "ssh_public_keys" {
    description = "List of public SSH keys"
    type = list(string)
}

variable "ssh_key" {
	type = string
}

variable "token_id" {
	description = "Name of token in proxmox, 'root@<auth>!<unique_name>'"
	type = string
}

variable "token_secret" {
    description = "Unique token value"
    type = string
}

variable "ciuser" {
	default = "grant"
	type = string
}

variable "cipassword" {
	description = "Common password for VM conf"
	type = string
}

variable "pm_api_url" {
	description = "Server url for proxmox"
	type = string
}

variable "clone_template" {
	default = "ubuntu-lts-24-04-template"
	type = string
}

variable "target_node" {
	default = "splinkus-pve"
	type = string
}

variable "vm_static_ip" {
	default = "192.168.5.50"
	type = string
}