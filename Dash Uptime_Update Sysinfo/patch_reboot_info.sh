#!/bin/bash
################################################################################
# Script Name : patch_reboot_info.sh
# Description : Script que coleta dados para o Dashboard: UNIX/LINUX - System report - Uptime / Update / Version
#
# Author      : Marcos Fábio Mesquita de Oliveira
# Created On  : <2025-07-25>
# Version     : <v1.0>
#
# Usage       : ./patch_reboot_info.sh
# Example     : ./patch_reboot_info.sh
#
# Dependencies: Access root from server
# Target OS   : <AIX/LINUX>
#
# Change Log  :
# -------------------------------------------------------------------------------
# Date        | Author        | Version | Description
# ----------- | ------------- | ------- | --------------------------------------
# 2025-02-20  | <Marcos F>    | v1.0    | Initial version
# 2025-07-25  | <Name>        | v1.1    | Change rpm command 
################################################################################

# Variáveis

HOSTNAME=$(uname -n)

# Detecta o sistema operacional

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$ID
elif [ "$(uname)" = "AIX" ]; then
    OS_NAME="aix"
else
    echo "Sistema operacional não identificado ou não suportado."
    exit 1
fi

# Lógica de execução com base no sistema operacional detectado
case "$OS_NAME" in
    rhel|redhat)
        echo "Red Hat identificado. Executando ação para Red Hat..."
        
        RHEL_LAST_UPDATE=$(rpm -qi $(rpm -qa | grep -i kernel | grep "`uname -a | awk '{print $3}'`") | grep "Install Date" | awk '{print $4" "$5" "$6}'| head -n 1)
        LAST_REBOOT=$(who -b | awk '{print $3,$4,$5}')
        OS_VERSION=$(grep "PRETTY_NAME" /etc/os-release | cut -d"=" -f2)

        # Input dos dados no CSV para coleta do Grafana

        rm /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        touch /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        chown gerunix /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        echo "$HOSTNAME;$RHEL_LAST_UPDATE;$LAST_REBOOT;$OS_VERSION" > /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv  


        ;;
    sles|suse)
        echo "SUSE Linux identificado. Executando ação para SUSE..."

        SUSE_LAST_UPDATE=$(rpm -qi $(rpm -qa | grep -i kernel | grep "`rpm -q kernel-default`")  | grep "Install Date" | awk '{print $4" "$5" "$6}'| head -n 1)
        LAST_REBOOT=$(who -b | awk '{print $3,$4,$5}')
        OS_VERSION=$(grep "PRETTY_NAME" /etc/os-release | cut -d"=" -f2)

        # Input dos dados no CSV para coleta do Grafana

        rm /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        touch /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        chown gerunix /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        echo "$HOSTNAME;$SUSE_LAST_UPDATE;$LAST_REBOOT;$OS_VERSION" > /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv       


        ;;
    aix)
        echo "AIX identificado. Executando ação para AIX..."

        AIX_LAST_UPDATE="`lslpp -h bos.rte |grep APPLY |awk '{print $4}'`"
        LAST_REBOOT="`who -b | awk '{print $4,$5,$6}'`"
        OS_VERSION="`oslevel -s`"

        # Input dos dados no CSV para coleta do Grafana

        rm /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        touch /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        chown gerunix /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv
        echo "$HOSTNAME;$AIX_LAST_UPDATE;$LAST_REBOOT;$OS_VERSION" > /so_ibm/scripts/"$HOSTNAME"_last_reboot_update.csv


        ;;
    *)
        echo "Sistema operacional não suportado: $OS_NAME"
        exit 2
        ;;
esac

