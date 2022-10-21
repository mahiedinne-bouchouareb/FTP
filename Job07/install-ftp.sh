#!/bin/bash

# Installation des paquets Proftpd. 
apt install proftpd-*

# Mise a niveau du sytème.
apt -y update && apt -y upgrade

# Copie et backup du fichier proftpd .
cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd_backup

# Décommente la section anonymous et la section tls.
sed -i '164,203 s/^#//g' /etc/proftpd/proftpd.conf
sed -i '143 s/^#//g' /etc/proftpd/proftpd.conf

# Copie du fichier tls pour disposer d'un backup.
cp /etc/proftpd/tls.conf /etc/proftpd/tls_backup.conf

# Décommente les sections du fichier tls pour config le server en FTPS
sed -i '9,12 s/^#//g' /etc/proftpd/tls.conf
sed -i '27,28 s/^#//g' /etc/proftpd/tls.conf
sed -i '45 s/^#//g' /etc/proftpd/tls.conf
sed -i '49 s/^#//g' /etc/proftpd/tls.conf

# On génère le certificat et les clés (privé est publique) ssl
openssl genrsa -out /etc/ssl/private/proftpd.key 1024
openssl req -new -x509 -days 3650 -key /etc/ssl/private/proftpd.key -out /etc/ssl/certs/proftpd.crt -passin pass "" \
        -subj '/C= /ST= /L= /O= /OU= /CN= /emailAddress= '

# redemarage pour prendre en compte les changements apportés.
systemctl start proftpd.service