resource "pfsense_firewall_ip_alias" "metallb_virt_ips" {
    name = "metallb_virt_ips"
    type = "host"
    entries = [
        for i in range(var.start_virt_ip, var.end_virt_ip):
        {
        address = "192.168.5.${i}"
        }
    ]
}
