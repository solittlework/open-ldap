FROM debian:stretch-slim
MAINTAINER Rafael Römhild <rafael@roemhild.de>

# Install slapd and requirements
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get \
        install -y --no-install-recommends \
            slapd \
            ldap-utils \
            openssl \
            ca-certificates \
             libcap2-bin \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /etc/ldap/ssl /bootstrap \

ENV LDAP_DEBUG_LEVEL=256

# ADD run script

# ADD bootstrap files
ADD ./bootstrap /bootstrap

# Initialize LDAP with data
RUN /bin/bash /bootstrap/slapd-init.sh

COPY ./run.sh /opt/run.sh
RUN chmod 755 /opt/run.sh
RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/slapd
RUN mkdir -p /etc/ldap/slapd.d && \
    chmod a+rwx -R /etc/ldap/slapd.d  && \
    mkdir -p /var/lib/ldap && \
    chmod a+rwx -R /var/lib/ldap && \
    mkdir -p /etc/ldap/ssl && \
    chmod a+rwx -R  /etc/ldap/ssl && \
    mkdir -p /run/slapd && \
    chmod a+rwx -R  /run/slapd && \
    mkdir -p /opt && \
    chmod a+rwx -R  /opt && \
    mkdir -p /usr/sbin/ && \
    chmod a+rwx -R  /usr/sbin/

USER 1001

EXPOSE 389 636
CMD ["/opt/run.sh"]