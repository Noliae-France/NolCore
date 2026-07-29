#!/bin/sh
set -eu

mkdir -p /certs
useradd -m -s /usr/sbin/nologin ci || true
mkdir -p /home/ci/Maildir/{cur,new,tmp}
chown -R ci:ci /home/ci/Maildir
if [ ! -f /certs/ca.crt ]; then
  openssl req -x509 -newkey rsa:2048 -nodes -days 2 \
    -subj '/CN=NolCore CI CA' -keyout /certs/ca.key -out /certs/ca.crt
  openssl req -newkey rsa:2048 -nodes -subj '/CN=smtp-test' \
    -keyout /certs/server.key -out /certs/server.csr
  printf 'subjectAltName=DNS:smtp-test\n' > /certs/server.ext
  openssl x509 -req -days 2 -in /certs/server.csr \
    -CA /certs/ca.crt -CAkey /certs/ca.key -CAcreateserial \
    -out /certs/server.crt -extfile /certs/server.ext
fi

postconf -e 'myhostname = smtp-test'
postconf -e 'inet_interfaces = all'
postconf -e 'mynetworks = 0.0.0.0/0'
postconf -e 'mydestination = localhost, localhost.localdomain, smtp-test'
postconf -e 'smtpd_tls_cert_file = /certs/server.crt'
postconf -e 'smtpd_tls_key_file = /certs/server.key'
postconf -e 'smtpd_tls_security_level = may'
postconf -e 'smtpd_tls_auth_only = yes'
postconf -e 'smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination'
postconf -M 'smtps/inet=465 inet n - y - - smtpd'
postconf -P 'smtps/inet/smtpd_tls_wrappermode=yes'
postconf -P 'smtps/inet/smtpd_tls_security_level=encrypt'
postconf -M 'submission/inet=587 inet n - y - - smtpd'
postconf -P 'submission/inet/smtpd_tls_security_level=encrypt'
postconf -P 'submission/inet/smtpd_tls_auth_only=no'

printf '%s\n' \
  'protocols = imap' \
  'mail_location = maildir:~/Maildir' \
  'ssl = no' \
  'disable_plaintext_auth = no' \
  > /etc/dovecot/dovecot.conf
dovecot

postfix start
trap 'postfix stop; exit 0' TERM INT
tail -F /var/log/mail.log /dev/null &
wait
