tls {
  defaults {
    verify_incoming = false
    verify_outgoing = true
    ca_file = "/etc/consul/ssl/local_ca_l1.crt"
    cert_file = "/etc/consul/ssl/consul.crt"
    key_file = "/etc/consul/ssl/consul-key.pem"
  }
  internal_rpc {
    verify_server_hostname = false
  }
}

ports {
  https = 8501
}
