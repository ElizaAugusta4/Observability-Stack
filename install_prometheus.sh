#!/bin/bash

set -e 

# Atualiza a lista de pacotes
apt update

# Instala o Prometheus e o Node Exporter a partir do repositório oficial
apt install -y prometheus prometheus-node-exporter

# Inicia e habilita o Prometheus e o Node Exporter
systemctl enable --now prometheus
systemctl enable --now prometheus-node-exporter

# Verifica o status do serviço Prometheus
service prometheus status

# Verifica o status do serviço Node Exporter
service prometheus-node-exporter status

# Testa o endpoint de métricas do Prometheus
curl http://127.0.0.1:9090/metrics

# Mostra o usuário prometheus
id prometheus

# Lista os processos rodando sob o usuário prometheus
ps -u prometheus

# Verifica as portas e conexões do Prometheus
ss -ntlp | grep prometheus

# Testa o endpoint de métricas do Node Exporter
curl http://127.0.0.1:9100/metrics
