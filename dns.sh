#!/bin/bash -e

DOMAIN_JSON=${DOMAIN_JSON:-'{}'}
RECORD_JSON=${RECORD_JSON:-'{}'}
# by default send queries to all servers that can reply
DNSMASQ_OPTIONS=${DNSMASQ_OPTIONS:---all-servers}

function configure_domain() {
  cat << EOF > /etc/dnsmasq.conf
user=root
$(jq '. as $servers|keys[]|. as $domain|$servers[$domain][]|"server=/"+$domain+"/"+.' -r)
EOF
}

function configure_record() {
  cat << EOF >> /etc/dnsmasq.conf
user=root
$(jq '. as $servers|keys[]|. as $domain|$servers[$domain][]|"address=/"+$domain+"/"+.' -r)
EOF
}

function run() {
  exec dnsmasq -k $DNSMASQ_OPTIONS
}

echo $DOMAIN_JSON | configure_domain
echo $RECORD_JSON | configure_record
run
