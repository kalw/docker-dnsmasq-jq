# dnsmasq-jq

## WAT?

A DNSMasq container configured via environment variable

## HOW?

Specify a set of domains or records to map to ips and ports like so:
`DOMAIN_JSON='{"local": ["127.0.0.1@50053"], "*": ["8.8.8.8"]}'`
`RECORD_JSON='{"my.gtld": ["1.2.3.4"], "your.gtld": ["2.3.4.5"]}'`

The above config would send anything with a `.local` domain to 127.0.0.1 on
port 50053, while any other requests would go to 8.8.8.8 , will resolve `my.gtld` to 1.2.3.4 and `your.gtld` 2.3.4.5

Specify all you like. Keep it simple
