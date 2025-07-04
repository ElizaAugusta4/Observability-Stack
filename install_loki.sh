#!/bin/bash

set -e

echo "==> Instalando unzip se necessário..."
apt update -y
apt install -y unzip

echo "==> Baixando Loki..."
cd /usr/local/bin
curl -O -L "https://github.com/grafana/loki/releases/download/v3.2.0/loki-linux-amd64.zip"

echo "==> Descompactando Loki..."
unzip -o "loki-linux-amd64.zip"
chmod a+x "loki-linux-amd64"

echo "==> Baixando configuração padrão do Loki..."
wget -O /usr/local/bin/loki-local-config.yaml https://raw.githubusercontent.com/grafana/loki/v3.2.0/cmd/loki/loki-local-config.yaml

echo "==> Criando usuário loki..."
useradd --system loki || true

echo "==> Ajustando permissões..."
chown loki:loki /usr/local/bin/loki-linux-amd64
chown loki:loki /usr/local/bin/loki-local-config.yaml

echo "==> Criando serviço systemd..."
cat <<EOF > /etc/systemd/system/loki.service
[Unit]
Description=Loki service
After=network.target

[Service]
Type=simple
User=loki
ExecStart=/usr/local/bin/loki-linux-amd64 -config.file /usr/local/bin/loki-local-config.yaml

[Install]
WantedBy=multi-user.target
EOF

echo "==> Recarregando o systemd e iniciando o Loki..."
systemctl daemon-reload
systemctl start loki.service
systemctl enable loki.service

echo "==> Ajustando permissões do diretório temporário..."
mkdir -p /tmp/loki
chown -R loki:loki /tmp/loki

echo "==> Verificando status do Loki..."
systemctl status loki.service --no-pager

echo "✅ Loki instalado e rodando como serviço no systemd!"
