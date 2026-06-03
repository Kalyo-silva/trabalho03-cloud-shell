#!/bin/bash
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
        break
    elif [ $cmd -eq 4 ]; then
        break
    elif [ $cmd -eq 5 ]; then
        break
    elif [ $cmd -eq 6 ]; then
        break
    elif [ $cmd -eq 7 ]; then
        break
    elif [ $cmd -eq 8 ]; then
        break
    elif [ $cmd -eq 9 ]; then
        break
    elif [ $cmd -eq 0 ]; then
        break
    else
        echo "comando inválido, tente novamente."
    fi
done