# Install / Uninstall Forgejo

apt -y install mariadb-server

CREATE USER 'forgejo'@'%' IDENTIFIED BY 'passw0rd';

CREATE DATABASE forgejodb CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_bin';

GRANT ALL PRIVILEGES ON forgejodb.* TO 'forgejo'@'%';

FLUSH PRIVILEGES;
