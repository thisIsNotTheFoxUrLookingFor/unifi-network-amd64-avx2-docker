FROM mongo:7.0 AS build

RUN DEBIAN_FRONTEND=noninteractive apt-get update -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true --allow-unauthenticated \
  && apt-get -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true upgrade -yq --allow-unauthenticated \
  && DEBIAN_FRONTEND=noninteractive apt-get -yq install tzdata ca-certificates wget nano ubuntu-keyring curl binutils logrotate libcap2 \
  && wget -qO- https://dl.ui.com/unifi/unifi-repo.gpg   | tee /etc/apt/trusted.gpg.d/unifi-repo.gpg > /dev/null \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/unifi-repo.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti"   | tee /etc/apt/sources.list.d/ubnt-unifi-stable.list > /dev/null \
  && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::AllowInsecureRepositories=true -o Acquire::AllowDowngradeToInsecureRepositories=true --allow-unauthenticated update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq openjdk-17-jre-headless unifi

WORKDIR /scripts

COPY scripts /scripts

RUN chmod 555 /scripts/start.sh

CMD /scripts/start.sh
