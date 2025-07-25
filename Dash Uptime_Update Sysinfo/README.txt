Descrição Detalhada do Script de Coleta de Dados para Dashboard Grafana
Objetivo:

Desenvolver um script de automação para coletar dados básicos de servidores UNIX/Linux — incluindo hostname, tempo desde a última atualização, uptime do sistema e versão do sistema operacional — e alimentar um dashboard de monitoramento no Grafana. O objetivo é oferecer uma visão consolidada e atualizada da saúde e conformidade dos servidores no ambiente corporativo.

Funcionamento Geral:

O script é executado periodicamente (via cron, Ansible, ou systemd timer) em cada servidor monitorado. Ele coleta dados locais e os envia para uma base de dados (como InfluxDB, Prometheus Pushgateway, ElasticSearch, ou mesmo um arquivo JSON centralizado), que serve como fonte de dados para o Grafana.
