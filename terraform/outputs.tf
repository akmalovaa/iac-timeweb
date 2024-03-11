# Fetch IP address example twc_server.monitoring-server.networks[0].ips[1].ip
output "monitoring-server-ip" {
  value = twc_server.monitoring-server.main_ipv4
}