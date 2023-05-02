tls {
  defaults {
    verify_incoming = true
    verify_outgoing = true
    ca_file = "/etc/consul/ssl/dk_ca_l1.crt"
    cert_file = "/etc/consul/ssl/consul.crt"
    key_file = "/etc/consul/ssl/consul-key.pem"
  }
  internal_rpc {
    verify_server_hostname = true
  }
}
