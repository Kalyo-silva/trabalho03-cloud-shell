#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/backup.log"

#variaveis de origem e destino do backup
ORIGEM="build/servico-entregas"
DESTINO="backups"

# Data e hora para o nome do arquivo
DATA_HORA=$(date +"%Y-%m-%d_%H-%M")
#nome do arquivo de backup (com formato de data)
BACKUP="bkp_servico_entregas_${DATA_HORA}.tar.gz"


echo "==============================================="
echo " Script: 04_estrutura.sh"
echo " Descrição: Backup Automatizado"
echo "==============================================="
echo ""
echo "===== Ferramenta de Backup =====" | tee -a "$LOG_FILE"

# Registrando início do backup
echo "[$(date)] Iniciando backup..." | tee -a "$LOG_FILE"

#verificar se existe build do projeto criada
if [ ! -d "/app/$ORIGEM" ]; then
    echo "[$(date)] Falha ao localizar build para backup!!!" | tee -a "$LOG_FILE"
    read wait
    exit 1
fi

cd /app

#cria o arquivo de backup
# c -> create -> criar um novo arquivo
# z -> gzip -> método de compactação
# v -> verbose
# f -> file -> define que o próximo argumento será o nome do arquivo
tar -czvf "$DESTINO/$BACKUP" "$ORIGEM/" | tee -a "$LOG_FILE"

#validando se o arquivo foi criado corretamente
if [ -f "$DESTINO/$BACKUP" ]; then
    echo "[$(date)] Backup criado, disponível em: /app/$DESTINO/$BACKUP" | tee -a "$LOG_FILE"
else
    echo "[$(date)] Erro ao realizar o backup!!!" | tee -a "$LOG_FILE"
    read wait
    exit 1
fi

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair