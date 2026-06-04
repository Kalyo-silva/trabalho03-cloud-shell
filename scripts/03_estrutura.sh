#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/estrutura.log"

#variavel do local de build da aplicação
BUILD_DIR="/app/build"
PROJECT_DIR="$BUILD_DIR/servico-entregas"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

# criando o diretório de build caso não exista
mkdir -p "$BUILD_DIR"

echo "==============================================="
echo " Script: 03_estrutura.sh"
echo " Descrição: Criação da Estrutura de Diretórios"
echo "==============================================="
echo ""
echo "===== Criar estrutura do Sistema de Entregas =====" | tee -a "$LOG_FILE"

#validando se existe um build antigo e solicitando remover
if [ -d "$PROJECT_DIR" ]; then
    echo "Estrutura de build antiga encontrada, deseja remover? (s/N):"
    read cmd

    #verificando resposta atravez de um regex
    if [[ "$cmd" =~ ^[Ss]$ ]]; then
        echo "[$(date)] Removendo build antiga..." | tee -a "$LOG_FILE"
        #removendo o diretório antigo
        rm -rf "$PROJECT_DIR"
        echo "[$(date)] build antiga removida com sucesso!" | tee -a "$LOG_FILE" 
    else
        echo "[$(date)] Operação Cancelada!" | tee -a "$LOG_FILE" 
        read wait
        exit 0
    fi
fi

echo "[$(date)] Criando diretórios do projeto..." | tee -a "$LOG_FILE" 

# Criando os diretórios basícos do projeto [dentro do tema do projeto]
mkdir -p "$PROJECT_DIR"/{comprovantes,entregas,clientes,pedidos,logs,website}

#criando subdiretorios
mkdir -p "$PROJECT_DIR"/comprovantes/{entregas,assinaturas,coletas}
mkdir -p "$PROJECT_DIR"/logs/{website,pedidos,rastreio}

echo "[$(date)] Estrutura do projeto criada." | tee -a "$LOG_FILE" 

#criando arquivos iniciais
touch "$PROJECT_DIR"/readme.md
touch "$PROJECT_DIR"/logs/website/logs_website.log
touch "$PROJECT_DIR"/logs/pedidos/logs_pedidos.log
touch "$PROJECT_DIR"/logs/rastreio/logs_rastreio.log
touch "$PROJECT_DIR"/comprovantes/entregas/entrega.png
touch "$PROJECT_DIR"/comprovantes/assinaturas/assinatura.png
touch "$PROJECT_DIR"/comprovantes/coletas/coleta.png

#copiando o website para dentro do build
cp -r /app/source/* "$PROJECT_DIR"/website/ 

echo "[$(date)] Arquivos iniciais criados." | tee -a "$LOG_FILE" 

echo "Estrutura gerada:"

#validando se o tree foi instalado e caso contrario, rodar o comando find
tree "$PROJECT_DIR" || find "$PROJECT_DIR"

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair