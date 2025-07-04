apt install nginx

nginx -v

service nginx status#!/bin/bash

set -e

echo "==> Atualizando pacotes..."
apt update -y

echo "==> Instalando Nginx..."
apt install -y nginx

echo "==> Verificando versão do Nginx..."
nginx -v

echo "==> Iniciando e habilitando Nginx no systemd..."
systemctl enable nginx
systemctl start nginx

echo "==> Verificando status do Nginx..."
systemctl status nginx --no-pager

echo "✅ Nginx instalado e rodando na porta 80!"
