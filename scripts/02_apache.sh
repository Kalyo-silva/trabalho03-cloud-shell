#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/apache.log"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

# definição da função 
instalar_apache(){
    #verifica se o apache ja esta instalado antes de iniciar
    verificar_apache

    #caso não esteja instalado, prossegue com a instalação
    if [ $? -ne 0 ]; then   
        #loga a ação    
        echo "[$(date)] Iniciando instalação do apache..." | tee -a "$LOG_FILE"

        if apt-get install apache2 -y 2>&1 | tee -a "$LOG_FILE"; then
            echo "[$(date)] Instalação do Apache realizada com sucesso!" | tee -a "$LOG_FILE"
        else
            echo "[$(date)] Erro ao instalar o Apache, verifique o log em: $LOG_FILE" | tee -a "$LOG_FILE"        
            return 1
        fi

        #instalando o imageMagick como adicional relacionado ao tema [Comprovantes de entrega]
        #loga a ação
        echo "[$(date)] Instalando ImageMagick [Adicional do Tema]..." | tee -a "$LOG_FILE"

        if apt-get install imagemagick -y 2>&1 | tee -a "$LOG_FILE"; then
            echo "[$(date)] Instalação do ImageMagick realizada com sucesso!" | tee -a "$LOG_FILE"
        else
            echo "[$(date)] Erro ao instalar o ImageMagick, verifique o log em: $LOG_FILE" | tee -a "$LOG_FILE"        
        fi

        #finaliza a instalação
        echo "-- instalação finalizada, aperte ENTER para continuar --"
    else
        #retorna mensagem caso ja esteja instalado o apache
        echo "O apache já está instalado neste container."
    fi
}

verificar_apache(){
    #loga a ação
    echo "[$(date)] Verificando Status do Apache2..." | tee -a "$LOG_FILE"
    service apache2 status >> "$LOG_FILE"

    # roda o comando para obter o status
    service apache2 status 
    
    #caso o status seja diferente de erro, valida como instalado
    if [ $? -ne 1 ]; then   
        return 0
    else
        return 1
    fi
}

versao_apache(){
    #verifica se o apache ja esta instalado antes de iniciar
    verificar_apache

    #caso o apache esteja instalado, verifica a versão e loga a ação
    if [ $? -ne 1 ]; then   
        echo "[$(date)] Verificando Versão do Apache2..." | tee -a "$LOG_FILE"
        apache2 -v 2>&1 | tee -a "$LOG_FILE"
    else
        # mensagem caso não instalado
        echo "O apache Não está instalado neste container."
    fi
}

#submenu de configurações do apache
while true; do
    clear
    echo "=============================================="
    echo " Script: 02_apache.sh"
    echo " Descrição: Instalação do Apache no Container"
    echo "=============================================="
    echo ""
    echo "================ MENU APACHE ================="
    echo "[1] - Instalar o Apache"
    echo "[2] - Verificar Instalação do Apache"
    echo "[3] - Verificar Versão do Apache"
    echo "=============================================="
    echo "[0] - Sair"
    echo "=============================================="
    read cmd

    if [ $cmd -eq 1 ]; then
        instalar_apache
    elif [ $cmd -eq 2 ]; then
        verificar_apache
    elif [ $cmd -eq 3 ]; then
        versao_apache
    elif [ $cmd -eq 0 ]; then
        break
    else
        echo "comando inválido, tente novamente."
    fi

    #le uma variavel sem utilidade para permitir que seja visualizado o resultado antes do loop limpar a tela
    read wait
done

#após finalizar o menu, mostra a mensagem de fim do script.
echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair