#!/bin/sh
set -e
echo "starting slapd on port 389 and 636..."
exec /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" \
  -u openldap \
  -g openldap \
  -d ${LDAP_DEBUG_LEVEL}