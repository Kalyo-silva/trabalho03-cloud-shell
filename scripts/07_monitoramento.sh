#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/monitoramento.log"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

# Limites
LIMITE_CPU=80
LIMITE_MEMORIA=80
LIMITE_DISCO=80

#utiliza do vmstat para pegaras informações do uso de CPU 2 vezes com um intervalo de 1 segundo
# utiliza o comando tail -1 para pegar a ultima linha do resultado
# utiliza do awk para processar o resultado do tail, buscando o campo de cpu disponível e calculando o percentual de uso.
CPU_USO=$(vmstat 1 2 | tail -1 | awk '{print 100-$15}')

# busca a memória disponível utilizando o comando free
# pega o resultado do free e processa ele com o awk para realizar o cálculo do percentual de memoria em uso.
# /Mem:/ -> utiliza somente a linha que aparece as informações de memória
# $3 -> memória em uso
# $2 -> memoria total
MEMORIA_USO=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

# usa o comando df -h / para obter as informações do disco apartir da pasta root do container
# NR==2 -> o awk pegará a segunda linha do resultado obtido pelo df -h /
# gsub -> comando que substitui texto (neste caso removendo o % do resultado)
# $5 -> percentual de uso do disco
DISCO_USO=$(df -h / | awk 'NR==2 {gsub("%","",$5); print $5}')


realizar_monitoramento(){
    #executando e logando o monitoramento
    echo "==============================================="
    echo " Script: 07_monitoramento.sh"
    echo " Descrição: Monitoramento do sistema"
    echo "==============================================="
    echo ""

    echo "===== Iniciando Monitoramento =====" | tee -a "$LOG_FILE"
    echo "[$(date)] Iniciando monitoramento..." | tee -a "$LOG_FILE"

    #logando uso da cpu
    echo "[$(date)] Uso de CPU: [${CPU_USO}%]" | tee -a "$LOG_FILE"

    #validando se o uso da cpu esta dentro do limite de uso
    if [ "$CPU_USO" -ge "$LIMITE_CPU" ]; then
        echo "[AVISO] Uso de CPU acima de ${LIMITE_CPU}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] Uso de CPU normal" | tee -a "$LOG_FILE"
    fi

    #logando uso de memória
    echo "[$(date)] Uso de Memória: ${MEMORIA_USO}%" | tee -a "$LOG_FILE"

    #validando se o uso de memória esta dentro do limite de uso
    if [ "$MEMORIA_USO" -ge "$LIMITE_MEMORIA" ]; then
        echo "[AVISO] Uso de memória acima de ${LIMITE_MEMORIA}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] Uso de memória normal" | tee -a "$LOG_FILE"
    fi

    #logando o uso de disco
    echo "[$(date)]  Uso de Disco: ${DISCO_USO}%" | tee -a "$LOG_FILE"

    #validando se o uso de disco esta dentro do limite de uso
    if [ "$DISCO_USO" -ge "$LIMITE_DISCO" ]; then
        echo "[AVISO] Uso de disco acima de ${LIMITE_DISCO}%" | tee -a "$LOG_FILE"
    else
        echo "[OK] Uso de disco normal" | tee -a "$LOG_FILE"
    fi

    #logando o status do apache
    echo "[$(date)] Verificando Status do Apache..." | tee -a "$LOG_FILE"

    #Verificando se o apache esta rodando
    # >/dev/null não retorna o texto para o terminal
    # 2>&1 redireciona a saida do erro para o mesmo lugar que a saida padrão
    if service apache2 status >/dev/null 2>&1; then
        echo "[OK] Serviço do Apache Rodando!" | tee -a "$LOG_FILE"
    else
        echo "[AVISO] Serviço do Apache Parado ou Não Instalado." | tee -a "$LOG_FILE"
    fi

    echo "===== Finalizado Monitoramento =====" | tee -a "$LOG_FILE"
}

realizar_monitoramento

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair
