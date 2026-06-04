#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/deploy.log"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

ORIGEM="/app/source"
DESTINO="/var/www/html"

echo "==============================================="
echo " Script: 05_deploy.sh"
echo " Descrição: Realizar o Deploy do Website"
echo "==============================================="
echo ""

#validando se o apache está instalado
echo "[$(date)] Verificando Status do Apache2..." | tee -a "$LOG_FILE"
# roda o comando para obter o status
service apache2 status 

#caso o status seja diferente de erro, valida como instalado
if [ $? -eq 1 ]; then   
    echo "[$(date)] ERRO: O apache2 não está instalado no container!" | tee -a "$LOG_FILE"
    
    #lendo valor inutil para segurar a aplicação até ser apertado enter
    read wait
    exit 1
fi

#iniciando o serviço do apache
echo "[$(date)] Iniciando o serviço do Apache2..." | tee -a "$LOG_FILE"
service apache2 start >> "$LOG_FILE"
echo "[$(date)] Serviço iniciado!" | tee -a "$LOG_FILE"

# removendo arquivos do destino
echo "[$(date)] Limpando diretório do destino antes do deploy..." | tee -a "$LOG_FILE"
rm -rf $DESTINO/*
echo "[$(date)] Diretórios Limpos!" | tee -a "$LOG_FILE"

#copiando os arquivos do source para o apache
echo "[$(date)] Copiando arquivos do website..." | tee -a "$LOG_FILE"
cp -r "$ORIGEM"/* "$DESTINO"
echo "[$(date)] Arquivos Copiados!" | tee -a "$LOG_FILE"

#listando os arquivos copiados
echo "Arquivos publicados:"
tree "$DESTINO" || find "$DESTINO"  

#validando se o index foi publicado corretamente
if [ -f "$DESTINO/index.html" ]; then
    echo "[$(date)] Validado arquivo index.html!" | tee -a "$LOG_FILE"
    echo "[$(date)] Website disponivel em: http://localhost:8080" | tee -a "$LOG_FILE"
else
    echo "[$(date)] ERRO: Falha ao localizar arquivo index.html!" | tee -a "$LOG_FILE"
    exit 1
fi

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair
