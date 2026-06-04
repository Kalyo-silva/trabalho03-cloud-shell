#!/bin/bash

#variaveis do local do arquivo
LOG_DIR="/app/logs"
LOG_FILE="$LOG_DIR/permisoes.log"

GRUPO="entregas_ops"
USUARIO_ENTREGA="entrega_user"
USUARIO_WEBSITE="website_user"
USUARIO_INFRAESTRUTURA="infra_user"
DIRETORIO="/app/build/servico-entregas"

echo "==============================================="
echo " Script: 08_usuarios_permissoes.sh"
echo " Descrição: Grupos, Usuários e Permissões"
echo "==============================================="
echo ""
echo "===== Criando Grupo de Usuários =====" | tee -a "$LOG_FILE"

echo "[$(date)] Criando grupo de usuários: $GRUPO..." | tee -a "$LOG_FILE"

#validando se o grupo ja foi criado
#getent group -> lista os grupos existentes (no caso do if, filtra para verificar se o grupo já existe)
# > /dev/null não retorna mensagem na tela
if getent group "$GRUPO" > /dev/null; then
    echo "[AVISO] Grupo $GRUPO já existe."
else
    #cria o grupo
    groupadd "$GRUPO"

    #valida se o grupo foi criado com sucesso
    if [ $? -eq 0 ]; then
        echo "[SUCESSO] Grupo $GRUPO criado."
    else
        echo "[ERRO] Falha ao criar grupo." 
    fi
fi

echo "===== Criando Usuários =====" | tee -a "$LOG_FILE"

echo "[$(date)] Criando usuário: $USUARIO_ENTREGA..." | tee -a "$LOG_FILE"

#valida se o usuário já existe
# comando id retorna informações sobre o usuário
# > /dev/null não retorna mensagem na tela
# 2>&1 redireciona a saida do erro para o mesmo lugar que a saida padrão
if id "$USUARIO_WEBSITE" > /dev/null 2>&1; then
    echo "[AVISO] Usuário $USUARIO_ENTREGA já existe."
else
    #adiciona o usuário ao grupo
    # -g define o grupo do usuario
    useradd -g "$GRUPO" "$USUARIO_ENTREGA"

    if [ $? -eq 0 ]; then
        echo "[SUCESSO] Usuário $USUARIO_ENTREGA criado."
    else
        echo "[ERRO] Falha ao criar usuário."
    fi
fi

echo "[$(date)] Criando usuário: $USUARIO_WEBSITE..." | tee -a "$LOG_FILE"

#fazendo a mesma coisa para o usuário website
if id "$USUARIO_WEBSITE" > /dev/null 2>&1; then
    echo "[AVISO] Usuário $USUARIO_WEBSITE já existe."
else
    #adiciona o usuário ao grupo
    useradd -g "$GRUPO" "$USUARIO_WEBSITE"

    if [ $? -eq 0 ]; then
        echo "[SUCESSO] Usuário $USUARIO_WEBSITE criado."
    else
        echo "[ERRO] Falha ao criar usuário."
    fi
fi


echo "[$(date)] Criando usuário: $USUARIO_INFRAESTRUTURA..." | tee -a "$LOG_FILE"

#fazendo a mesma coisa para o usuário Infraestrutura
if id "$USUARIO_INFRAESTRUTURA" > /dev/null 2>&1; then
    echo "[AVISO] Usuário $USUARIO_INFRAESTRUTURA já existe."
else
    #adiciona o usuário ao grupo
    useradd -g "$GRUPO" "$USUARIO_INFRAESTRUTURA"

    if [ $? -eq 0 ]; then
        echo "[SUCESSO] Usuário $USUARIO_INFRAESTRUTURA criado."
    else
        echo "[ERRO] Falha ao criar usuário."
    fi
fi

echo "===== Aplicando Permissões de Usuário =====" | tee -a "$LOG_FILE"

#valida se o diretório do build da aplicação foi criado
if [ -d "$DIRETORIO" ]; then
    #definindo o usuário de Infraestrutura como dono do projeto
    chown -R "$USUARIO_INFRAESTRUTURA:$GRUPO" "$DIRETORIO"

    # definindo o Proprietário e grupo do diretório de Entregas para o usuário entrega_user
    chown -R "$USUARIO_ENTREGA:$GRUPO" "$DIRETORIO/entregas"

    # definindo o Proprietário e grupo do diretório do website para o usuário website_user
    chown -R "$USUARIO_WEBSITE:$GRUPO" "$DIRETORIO/website"

    # Dando permissões para todos os diretórios / subdiretórios do build recursivamente
    # 7 -> Dono (acesso total)
    # 5 -> Grupo (Leitura e Execução)
    # 0 -> Outros (Nenhuma permissão)

    chmod -R 750 "$DIRETORIO"

    # vale ressaltar que como foram definidos os donos de cada subdiretório para os usuários entregas e website,
    # estes usuários terão acesso completo dentro de seus respectivos diretórios.
    echo "[SUCESSO] Permissões aplicadas."
else
    echo "[ERRO] Diretório $DIRETORIO Não existe, Por favor execute o script [03_estrutura.sh]"
fi

echo ""
echo "-- script finalizado, aperte ENTER para sair. --"
read sair


