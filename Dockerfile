FROM akamai/shell

LABEL "com.github.actions.name"="Akamai Edge DNS API"
LABEL "com.github.actions.description"="Deploy Akamai Edge DNS Zones via the Akamai DNS API"
LABEL "com.github.actions.icon"="cloud-lightning"
LABEL "com.github.actions.color"="orange"

LABEL version="0.1.0"
LABEL repository="https://github.com/akamai-contrib/akamai-deploy-dns-zone-github-action"
LABEL homepage=""
LABEL maintainer="Javier Garza <dgithub@javiergarza.net>"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
