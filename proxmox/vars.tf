variable "ssh_public_keys" {
    description = "List of public SSH keys"
    type = list(string)
}

variable "token_id" {
	description = "Name of token in proxmox, 'root@<auth>!<unique_name>'"
	type = string
}

variable "token_secret" {
    description = "Unique token value"
    type = string
}

variable "common_pass" {
	description = "Common password for VM conf"
	type = string
}

variable "pm_api_url" {
	description = "Server url for proxmox"
	type = string
}