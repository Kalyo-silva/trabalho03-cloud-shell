#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/update.log"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

# definição da função 
atualizar_sistema() {
    # utilizando do comando tee para mostrar a mensagem no terminal e também escrever ela no arquivo de log
    # parâmetro -a significa append: incrementa o arquivo existente
    echo "[$(date)] Iniciando atualização do sistema..." | tee -a "$LOG_FILE"

    # realizando o comando apt update dentro de um if para caso ocorra uma falha ele retorne a mensagem de erro.
    # o comando 2>&1 permite que tanto as mensagens de sucesso quanto erros sejam escritas no arquivo de log
    if apt update 2>&1 | tee -a "$LOG_FILE"; then
        echo "[$(date)] Apt update concluído com sucesso." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] ERRO: Falha durante a atualização do sistema." | tee -a "$LOG_FILE"
        return 1
    fi


    # após o apt update, realizando o comando apt upgrade da mesma maneira.
    if apt upgrade -y 2>&1 | tee -a "$LOG_FILE"; then
        echo "[$(date)] Apt upgrade concluído com sucesso." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] ERRO: Falha durante a atualização do sistema." | tee -a "$LOG_FILE"
        return 1
    fi

    # se passou todas as etapas, retorna sucesso para o script
    return 0
}

# executar a função

echo "=========================================="
echo " Script: 01_update.sh"
echo " Descrição: Atualização do sistema Ubuntu"
echo "=========================================="
atualizar_sistema

# utiliza do $? para verificar o código de status que a função retornou e se ele for sucesso
# mostra mensagem de sucesso, caso contrário, retorna erro e aponta para o arquivo de log.
if [ $? -eq 0 ]; then
    echo "===== Sistema atualizado com sucesso. ====="
else
    echo "!!!! Falha na atualização do sistema. Consulte o log em: $LOG_FILE !!!!"
fi

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair