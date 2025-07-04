#!/bin/bash

set -e

echo "==> Atualizando pacotes..."
apt update -y

echo "==> Instalando MySQL Server..."
DEBIAN_FRONTEND=noninteractive apt install -y mysql-server

echo "==> Verificando status do MySQL..."
service mysql status

echo "==> Baixando arquivo de schema my2_80.sql..."
wget -O /tmp/my2_80.sql https://raw.githubusercontent.com/meob/my2Collector/master/my2_80.sql

echo "==> Ajustando permissões de usuário no script my2_80.sql..."
cat <<EOF >> /tmp/my2_80.sql

-- User creation
CREATE USER IF NOT EXISTS 'my2'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON my2.* TO 'my2'@'localhost';
GRANT SELECT ON performance_schema.* TO 'my2'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "==> Aplicando script SQL..."
mysql < /tmp/my2_80.sql

echo "==> Listando databases..."
mysql -e "show databases;"

echo "==> Criando usuário grafana (altere o IP e senha abaixo conforme necessário)..."
mysql -e "CREATE USER IF NOT EXISTS 'grafana'@'192.168.0.100' IDENTIFIED BY 'password';"
mysql -e "GRANT SELECT ON my2.* TO 'grafana'@'192.168.0.100';"
mysql -e "FLUSH PRIVILEGES;"

echo "==> Ajustando bind-address para 0.0.0.0..."
sed -i '/^\[mysqld\]/a bind-address = 0.0.0.0' /etc/mysql/my.cnf || echo -e "[mysqld]\nbind-address=0.0.0.0" >> /etc/mysql/my.cnf

echo "==> Reiniciando MySQL..."
service mysql restart

echo "✅ MySQL instalado, configurado e pronto para o Grafana!"
