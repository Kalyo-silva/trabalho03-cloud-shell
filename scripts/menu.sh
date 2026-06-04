#!/bin/bash

menu(){
    while true; do
        clear

        echo "Criado por: Kalyo Airan da Silva"
        echo "Instituição: Unidavi"
        echo "Tema: Infraestrutura para um Pequeno Serviço de Entregas"
        echo ""
        echo "============ MENU DEVOPS CLOUD ============"
        echo "[1] - Atualizar sistema"
        echo "[2] - Instalar Apache"
        echo "[3] - Criar estrutura do projeto"
        echo "[4] - Realizar backup"
        echo "[5] - Fazer deploy"
        echo "[6] - Ver processos"
        echo "[7] - Monitorar sistema"
        echo "[8] - Configurar usuários e permissões"
        echo "[9] - Gerar relatório"
        echo "==========================================="
        echo "[0] - Sair"
        echo "==========================================="
        read cmd

        clear

        if [ $cmd -eq 1 ]; then
            ./01_update.sh
        elif [ $cmd -eq 2 ]; then
            ./02_apache.sh
        elif [ $cmd -eq 3 ]; then
            ./03_estrutura.sh
        elif [ $cmd -eq 4 ]; then
            ./04_backup.sh
        elif [ $cmd -eq 5 ]; then
            ./05_deploy.sh
        elif [ $cmd -eq 6 ]; then
            echo "Comando: "
            read cmd

            if [[ "$cmd" == 'listar' ]]; then
                ./06_processos.sh listar
            elif [[ "$cmd" == 'buscar' ]]; then
                echo "Processo: "
                read processo 

                ./06_processos.sh buscar $processo
            elif [[ "$cmd" == 'matar' ]]; then
                echo "PID: "
                read PID 

                ./06_processos.sh matar $PID
            else
                echo "$0"
                echo "commandos:"
                echo "  -> listar"
                echo "  -> buscar <nome>"
                echo "  -> matar <PID>"
                echo
                read wait
            fi
            
        elif [ $cmd -eq 7 ]; then
            ./07_monitoramento.sh
        elif [ $cmd -eq 8 ]; then
            ./08_usuarios_permissoes.sh
        elif [ $cmd -eq 9 ]; then
            ./09_relatorio.sh
        elif [ $cmd -eq 0 ]; then
            break
        else
            echo "comando inválido, tente novamente."
        fi
    done
}


menu