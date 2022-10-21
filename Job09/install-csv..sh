#!/bin/bash

addgroup ftp_users

sed 1d ftp_users.csv | while IFS=, read -r Id Prenom Nom Mdp Role; do
	user=$Prenom$Nom
	newuser=$(echo "${user}" | tr -d '[:space:]')
	sudo useradd -m -p $(openssl passwd -1 $Mdp) $newuser
	if [ $Role=A* ]; then
		usermod -aG sudo $newuser
	fi
	addgroup ftp_users
		usermod -aG ftp_users $newuser
	sed -i '74 s/nogroup/$ftp_users/g' /etc/proftpd/proftpd.conf

done 
