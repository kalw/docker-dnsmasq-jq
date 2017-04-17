FROM alpine

RUN apk add --update dnsmasq jq bash

RUN echo -e "#!/bin/bash -e\n\
set -x\n\
DOMAIN_JSON=\${DOMAIN_JSON:-'{\"*\": [\"8.8.8.8\"]}'}\n\
RECORD_JSON=\${RECORD_JSON:-'{}'}\n\
# by default send queries to all servers that can reply\n\
DNSMASQ_OPTIONS=\${DNSMASQ_OPTIONS:---all-servers}\n\
\n\
function configure_domain() {\n\
  cat << EOF > /etc/dnsmasq.conf\n\
user=root\n\
\$(jq '. as \$servers|keys[]|. as \$domain|\$servers[\$domain][]|\"server=/\"+\$domain+\"/\"+.' -r)\n\
EOF\n\
}\n\
\n\
function configure_record() {\n\
  cat << EOF >> /etc/dnsmasq.conf\n\
\$(jq '. as \$servers|keys[]|. as \$domain|\$servers[\$domain][]|\"address=/\"+\$domain+\"/\"+.' -r)\n\
EOF\n\
}\n\
\n\
function run() {\n\
  exec dnsmasq -k \${DNSMASQ_OPTIONS}\n\
}\n\
\n\
echo \${DOMAIN_JSON} | configure_domain\n\
echo \${RECORD_JSON} | configure_record\n\
run\n\
" > /dns.sh
RUN chmod +x /dns.sh

CMD /dns.sh
