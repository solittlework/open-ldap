#!/bin/sh
ulimit -n 1024
OPENLDAP_DEBUG_LEVEL=${OPENLDAP_DEBUG_LEVEL:-256}

echo "starting slapd on port 389 and 636..."
exec /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" \
  -d ${OPENLDAP_DEBUG_LEVEL}