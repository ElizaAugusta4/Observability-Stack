#!/bin/bash

set -e

echo "==> Baixando Promtail..."
cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v3.2.0/promtail-linux-amd64.zip"

echo "==> Descompactando Promtail..."
unzip -o "promtail-linux-amd64.zip"
chmod a+x "promtail-linux-amd64"

echo "==> Baixando configuração padrão do Promtail..."
wget -O /usr/local/bin/promtail-local-config.yaml https://raw.githubusercontent.com/grafana/loki/v3.2.0/clients/cmd/promtail/promtail-local-config.yaml

echo "==> Criando usuário promtail..."
useradd --system promtail || true

echo "==> Ajustando permissões do binário e config..."
chown promtail:promtail /usr/local/bin/promtail-linux-amd64
chown promtail:promtail /usr/local/bin/promtail-local-config.yaml

echo "==> Criando serviço systemd..."
cat <<EOF > /etc/systemd/system/promtail.service
[Unit]
Description=Promtail service
After=network.target

[Service]
Type=simple
User=promtail
ExecStart=/usr/local/bin/promtail-linux-amd64 -config.file /usr/local/bin/promtail-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF

echo "==> Adicionando promtail ao grupo adm (leitura dos logs do sistema)..."
usermod -a -G adm promtail

echo "==> Ajustando permissões do arquivo de positions..."
touch /tmp/positions.yaml
chown promtail:promtail /tmp/positions.yaml

echo "==> Recarregando o systemd e iniciando o serviço Promtail..."
systemctl daemon-reload
systemctl start promtail.service
systemctl enable promtail.service

echo "==> Verificando status do serviço..."
systemctl status promtail.service --no-pager

echo "✅ Promtail instalado e rodando como serviço no systemd!"
