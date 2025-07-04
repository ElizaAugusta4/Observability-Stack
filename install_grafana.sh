#!/bin/bash

set -e

echo "==> Atualizando pacotes..."
apt update -y

echo "==> Instalando dependências..."
apt-get install -y adduser libfontconfig1 musl wget

echo "==> Baixando pacote do Grafana 11.2.0..."
wget -O /tmp/grafana_11.2.0_amd64.deb https://dl.grafana.com/oss/release/grafana_11.2.0_amd64.deb

echo "==> Instalando Grafana..."
dpkg -i /tmp/grafana_11.2.0_amd64.deb

echo "==> Iniciando o serviço grafana-server..."
systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

echo "==> Verificando status do Grafana..."
systemctl status grafana-server --no-pager

echo "✅ Grafana 11.2.0 instalado e rodando na porta 3000!"
