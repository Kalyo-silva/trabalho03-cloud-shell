#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/processos.log"

echo "==============================================="
echo " Script: 06_processos.sh"
echo " Descrição: Gereciamento de processos"
echo "==============================================="
echo ""

listar_processos(){
    echo "===== Processos Ativos ====="
    echo "[$(date)] Buscando processos..." | tee -a "$LOG_FILE"

    # utilizando do comando ps para verificar os processos
    # a -> processos de todos os usuários
    # u -> formato detalhado de exibição
    # x -> incluir serviços e processos que não possuem terminal associado
    ps aux | tee -a "$LOG_FILE"
}

buscar_processo(){
    #declarando variavel local que vai receber o parâmetro
    local PROCESSO="$1"

    # if com -z para verificar se foi informado algum processo para buscar
    if [ -z "$PROCESSO "]; then
        echo "[$(date)] Erro: nome do processo não informado." | tee -a "$LOG_FILE"
    else
        echo "[$(date)] Buscando pelo processo [$PROCESSO]..." | tee -a "$LOG_FILE"

        #utilizando o grep na lista de processos para encontrar somente os relacionados ao nome informado
        # -i para ignorar case sensitivity
        # -v para ignorar o comando do próprio grep buscando pelo processo
        ps aux | grep -i "$PROCESSO" | grep -v grep | tee -a "$LOG_FILE"
    fi
}


matar_processo() {
    #declarando variavel local para receber o PID do processo
    local PID="$1"

    #validando se foi informado um PID
    if [ -z "$PID" ]; then
        echo "[$(date)] Erro: PID não informado." | tee -a "$LOG_FILE"
    else
        # usando RegEx para validar se o PID contem somente números
        if ! [[ "$PID" =~ ^[0-9]+$ ]]; then
            echo "[$(date)] Erro: PID inválido: $PID." | tee -a "$LOG_FILE"
        else
            # verificando se o PID informado existe realmente
            # utiliza de > /dev/null para não exibir a mesagem do processo na tela
            # 2>&1 redireciona a saida do erro para o mesmo lugar que a saida padrão
            if ! ps -p "$PID" > /dev/null 2>&1; then
                echo "[$(date)] Erro: Processo não encontrado com o PID [$PID]." | tee -a "$LOG_FILE"
            else
                #confirma exclusão do processo
                echo "[$(date)] Confirmar encerrar o processo de PID [$PID]? (s/N)" | tee -a "$LOG_FILE"
                read cmd

                #validando com regEx se o comando não for s ou S
                if [[! "$cmd" =~ ^[Ss]$ ]]; then
                    echo "[$(date)] Operação cancelada." | tee -a "$LOG_FILE"
                else
                    #tentando matar o processo
                    if kill "$PID"; then
                        echo "[$(date)] Processo $PID encerrado com sucesso." | tee -a "$LOG_FILE"
                        exit 0
                    else
                        echo "[$(date)] Falha ao encerrar o processo $PID." | tee -a "$LOG_FILE"
                    fi
                fi
            fi
        fi
    fi

    #retornando erro caso não passe por todas as validações
    exit 1
}


#orquestrando as operações recebidas via command line
if [[ "$1" == 'listar' ]]; then
    listar_processos
elif [[ "$1" == 'buscar' ]]; then
    buscar_processo "$2"
elif [[ "$1" == 'matar' ]]; then
    matar_processo "$2"
else
    echo "$0"
    echo "commandos:"
    echo "  -> $0 listar"
    echo "  -> $0 buscar <nome>"
    echo "  -> $0 matar <PID>"
    echo
fi

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair
