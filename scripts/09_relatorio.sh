#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
RELATORIO="$LOG_DIR/relatorio_execucao.txt"

# criar diretório de logs caso não exista
mkdir -p "$LOG_DIR"

#informações do projeto
PROJETO="Easy Delivery Co."
TEMA="Infraestrutura para um Pequeno Serviço de Entregas"

# Estrutura utilizada nas tarefas anteriores
BACKUP_DIR="/app/backups"
LOG_DIR="/app/logs"
BUILD_DIR="/app/build/"
PUBLICACAO_DIR="/var/www/html"

echo "==============================================="
echo " Script: 09_relatorio.sh"
echo " Descrição: Relatório de Execução"
echo "==============================================="
echo ""
echo "[$(date)] Gerando relatório..."

{
echo "========================================================"
echo "RELATÓRIO DE EXECUÇÃO AUTOMATIZADO"
echo "========================================================"
echo "Data/Hora : $(date '+%d/%m/%Y %H:%M:%S')"
echo "Projeto   : $PROJETO"
echo "Tema      : $TEMA"
echo

echo "========================================================"
echo "ESPAÇO EM DISCO"
echo "========================================================"
# df -h para buscar informações detalhadas sobre o disco
df -h
echo

echo "========================================================"
echo "USO DOS DIRETÓRIOS"
echo "========================================================"

#valida se o diretorio de build existe e da um tree para listar o seu conteudo
if [ -d "$BUILD_DIR" ]; then
    tree "$BUILD_DIR" || find "$BUILD_DIR"
else
    echo "Diretório $BUILD_DIR não encontrado."
fi

echo

echo "========================================================"
echo "STATUS DO APACHE"
echo "========================================================"

#valida status do apache 
if service apache2 status >/dev/null 2>&1; then
    echo "[OK] Serviço do Apache Rodando!" 
else
    echo "[AVISO] Serviço do Apache Parado ou Não Instalado." 
fi

echo

echo "========================================================"
echo "ÚLTIMOS BACKUPS"
echo "========================================================"

#valida se o diretorio de backups existe e da um tree para listar o seu conteudo
if [ -d "$BACKUP_DIR" ]; then
    tree "$BACKUP_DIR" || find "$BACKUP_DIR" | tail -5
else
    echo "Nenhum diretório de backup encontrado."
fi

echo

echo "========================================================"
echo "ÚLTIMOS LOGS"
echo "========================================================"

#valida se o diretorio de logs existe e da um tree para listar o seu conteudo
if [ -d "$LOG_DIR" ]; then
    tree "$LOG_DIR" || find "$LOG_DIR" | tail -10
else
    echo "Diretório de logs não encontrado."
fi

echo

echo "========================================================"
echo "ARQUIVOS PUBLICADOS"
echo "========================================================"

#valida se o diretorio de publicação do apache existe e da um tree para listar o seu conteudo
if [ -d "$PUBLICACAO_DIR" ]; then
    tree "$PUBLICACAO_DIR" || find "$PUBLICACAO_DIR"
else
    echo "Diretório de publicação não encontrado."
fi

echo

echo "========================================================"
echo "USUÁRIOS E PERMISSÕES"
echo "========================================================"

echo "Usuários criados para o projeto:"

#lista informações sobre cada usuário criado
grep "entrega_user" /etc/passwd
grep "website_user" /etc/passwd
grep "infra_user" /etc/passwd

echo
echo "Permissões principais:"

# se encontrar o diretório de build, lista as permissões de todos os arquivos inclusos atravez do -R (Recursivo)
if [ -d "$BUILD_DIR" ]; then
    ls -lR "$BUILD_DIR"/*
else
    echo "Diretório da aplicação não encontrado."
fi

echo

echo "========================================================"
echo "FIM DO RELATÓRIO"
echo "========================================================"

} > "$RELATORIO"

echo "[SUCESSO] Relatório gerado com sucesso."
echo "[$(date)] Relatório Disponível em: $RELATORIO."

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair