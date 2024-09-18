#!/bin/sh

if [ $USER = root ]; then

	if [ -z "$1" ]; then

	echo "Install dépendencies";
        	apt -y update
	        apt -y install git git-lfs


                echo "Install MariaDB";
                #apt -y install mariadb-server
                # CREATE USER 'forgejo'@'%' IDENTIFIED BY 'passw0rd';
                # CREATE DATABASE forgejodb CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_bin';
                # GRANT ALL PRIVILEGES ON forgejodb.* TO 'forgejo'@'%';
                # FLUSH PRIVILEGES;


        	wget https://codeberg.org/forgejo/forgejo/releases/download/v8.0.3/forgejo-8.0.3-linux-amd64
        	chmod +x forgejo-8.0.3-linux-amd64
        	echo "Get PGP key :";
        	gpg --keyserver keys.openpgp.org --recv EB114F5E6C0DC2BCDD183550A4B61A2DC5923710
        	wget https://codeberg.org/forgejo/forgejo/releases/download/v8.0.3/forgejo-8.0.3-linux-amd64.asc
        	gpg --verify forgejo-8.0.3-linux-amd64.asc forgejo-8.0.3-linux-amd64
        	echo "Copy to '/usr/local/bin' ";
        	cp forgejo-8.0.3-linux-amd64 /usr/local/bin/forgejo
        	chmod 755 /usr/local/bin/forgejo

        	echo "Create user 'git' .. ";
        	adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git

        	echo "Create directory ..";
        	mkdir /var/lib/forgejo
        	chown git:git /var/lib/forgejo && chmod 750 /var/lib/forgejo
        	mkdir /etc/forgejo
		chown root:git /etc/forgejo && chmod 770 /etc/forgejo

		echo "Install service .. "
		wget -O /etc/systemd/system/forgejo.service https://codeberg.org/forgejo/forgejo/raw/branch/forgejo/contrib/systemd/forgejo.service
		systemctl enable forgejo.service && systemctl start forgejo.service

		echo "Forgejo is installed !"
		echo "!!! EDIT /etc/systemd/system/forgejo.service !!!"
		echo "Uncomment the corresponding Wants= and After= lines. Otherwise it should work as it is."
		echo "Fix, if needed the paths"
		echo "Reload systemctl after modification with : 'systemclt daemon-reload' "
		echo "Fine tune with app.ini"
		echo "Connect for configuration to server at : http://localhost:3000";
		echo "View README for database installation and configuration"

		exit 0;
	elif [ "$1" = "--uninstall" ]; then
		echo "Uninstall forgejo";
		systemctl disable forgejo.service && systemctl stop forgejo.service
		rm -R /usr/local/bin/forgejo
		rm -R /var/lib/forgejo
		rm -R /etc/forgejo
		exit 0;
	elif [ -z "$1" || "$1" = "-help" ]; then
		echo "The '--uninstall' parameter will be give else install 'forgejo' "
	fi
fi

echo "The script must be executed with root or sudo !"
exit 0;

