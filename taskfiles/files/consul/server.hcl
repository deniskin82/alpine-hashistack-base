data_dir = "CONSUL_DATADIR"
datacenter = "CONSUL_DC"
bind_addr = "{{ GetInterfaceIP \"BIND_ETH\" }}"
client_addr = "0.0.0.0"
server = true
bootstrap_expect = 1
disable_update_check = true
disable_remote_exec = true
enable_syslog = true
ui_config {
  enabled = true
}
