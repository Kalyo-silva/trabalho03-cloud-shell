# Projeto de Automação Linux com Shell Script e Docker

## Autor

**Nome do Aluno:** Kalyo Airan da Silva

---

# Tema do Trabalho

**Tema:** Infraestrutura para um Pequeno Serviço de Entregas

---

# Descrição do Cenário

Este projeto foi desenvolvido com o objetivo de automatizar tarefas administrativas de um ambiente Linux utilizando Shell Script.

O cenário escolhido foi um sistema de gerenciamento de entregas, onde são realizadas atividades comuns de administração de servidores, tais como:

- Atualização do sistema operacional;
- Instalação de aplicações e ferramentas para funcionamento do servidor;
- Criação da estrutura de diretórios da aplicação;
- Geração de backups automatizados;
- Publicação de websites usando o Apache.
- Gerenciamento de processos;
- Monitoramento de recursos do servidor;
- Gerenciamento de usuários, grupos e permissões;
- Geração de relatórios operacionais.

O projeto foi desenvolvido visando demonstrar conhecimentos em administração Linux, automação com Shell Script e conteinerização de aplicações.

---

# Tecnologias Utilizadas

- Linux Ubuntu
- Bash Shell Script
- Apache HTTP Server
- Docker
- Docker Hub
- Git
- GitHub

---

# Estrutura de Pastas

```text
trabalho03-cloud-shell/
├── backups/ --> Pasta onde ficam armazenados backups dos builds da aplicação
├── build/ --> Pasta onde é realizado o build mais recente da aplicação
├── evidencias/ --> Pasta onde é documentado as evidências necessárias para o trabalho
├── logs/ --> Pasta onde são gerados logs e relatórios para consulta do funcionamento dos scripts
├── scripts/ --> Pasta contendo os scripts de execução das funções de gerenciamento e automação.
│   ├── 01_update.sh
│   ├── 02_apache.sh
│   ├── 03_estrutura.sh
│   ├── 04_backup.sh
│   ├── 05_deploy.sh
│   ├── 06_processos.sh
│   ├── 07_monitoramento.sh
│   ├── 08_usuarios_permissoes.sh
│   ├── 09_relatorio.sh
│   └── menu.sh
├── source/ --> Pasta contendo os arquivos necessários para o build do website 
│   ├── assets/
│   │   ├── background.jpg
│   │   ├── manutencao.avif
│   │   └── Site-logo.webp
│   ├── health.json 
│   ├── index.html
│   ├── manutencao.html
│   ├── sobre.html
│   └── tailwind.config.js
├── .env.example
├── Dockerfile
├── docker-compose.yml
└── README.md
```
---

# Como Executar o Projeto

## pré-requisitos

- Motor de containers do Docker em execução
- Git para realizar o clone do repositório

## instalação
Para executar este projeto, basta seguir os comandos abaixo:
```shell
# no prompt de comando do seu computador
git clone https://github.com/Kalyo-silva/trabalho03-cloud-shell.git

cd trabalho03-cloud-shell/

docker compose build -d --build

docker exec -it easydelivery-website bash

#dentro do terminal do ubuntu no container docker
cd scripts/

chmod +X *.sh

# Execute o menu principal para gerenciar todos os scripts a partir de um só lugar
./menu

# Ou também, scripts podem serem executados de forma individual
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```
---

# Como Validar o Website no Apache

Para esta situação, alguns scripts precisam ser executados antes da validação do website.

**Requisitos**
Dentro do Container docker, após executado comandos de instalação determinados acima, é necessário rodar:
-  **01_update.sh:** Para atualizar o sistema e baixar programas adicionais;
-  **02_apache.sh:** Para Instalar o Apache Web Server no container;
-  **03_estrutura.sh:** Para realizar o build da aplicação e criar as estruturas necessárias para o deploy
-  **05_deploy.sh:** Para realizar o deploy dos arquivos do website para o Web Server Apache

Após isso, o website estará disponível em: ```https://Localhost:8080/```

---
# Explicação dos Scripts

## 01_update.sh

**Responsável por:**

 - Atualizar os repositórios do sistema;
 - Atualizar os pacotes instalados;
 - Registrar logs da execução;
 - Informar sucesso ou falha da atualização.

## 02_apache.sh

**Responsável por:**

 - Realizar a Instalação do Apache2
 - Realiazar a instalação do imageMagick [Relacionado ao tema do trabalho, para a manipulação de imagens de comprovantes de entrega]
 - Verificar status do Apache
 - Detalhar Versão instalada do Apache
 
## 03_estrutura.sh

**Responsável por:**

 - Criar a estrutura de diretórios da aplicação;
 - Criar diretórios relacionados ao tema do projeto;
 - Copiar arquivos do website;
 - Remover builds antigas com segurança.

## 04_backup.sh

**Responsável por:**

 - Gerar backups compactados;
 - Utilizar formato .tar.gz;
 - Incluir data e hora no nome do arquivo;
 - Armazenar backups na pasta backups;
 - Registrar logs da execução.

Exemplo:

``` shell
backup_entregas_2026-06-04_21-30.tar.gz
```

## 05_deploy.sh

**Responsável por:**

- Realizar a copia do website do build para a pasta do apache;
- Iniciar o servidor apache;
- Limpar deploys antigos com segurança;
- Registrar logs do processo.

## 06_processos.sh

**Responsável por:**

- Listar processos ativos;
- Buscar processos por nome;
- Encerrar processos por PID;
- Validar parâmetros informados.

Exemplos:

``` shell
./06_processos.sh listar
./06_processos.sh buscar apache
./06_processos.sh matar 1234
```

## 07_monitoramento.sh

**Responsável por:**

 - Exibir utilização de CPU;
 - Exibir utilização de memória RAM;
 - Exibir utilização de disco;
 - Verificar status do Apache;
 - Gerar alertas quando recursos estiverem acima dos limites definidos.

Exemplo:
``` shell
[ALERTA] Uso de memória acima de 80%
[OK] Apache em execução
``` 

## 08_usuarios_permissoes.sh

**Responsável por:**

 - Criar grupos de usuários;
 - Criar usuários do sistema;
 - Configurar proprietários utilizando chown;
 - Configurar permissões utilizando chmod.
 - Aplicar permissões de acesso;
 
**Usuários criados:**

- entrega_user
- website_user
- infra_user

**Grupo criado:**

- entregas_ops

## 09_relatorio.sh

**Responsável por:**

- Gerar relatório operacional;
- Exibir uso de disco;
- Exibir utilização dos diretórios;
- Verificar status do Apache;
- Exibir últimos backups;
- Exibir usuários e permissões;

Salvar relatório em:

```shell
logs/relatorio_execucao.txt
```
---
# Evidências

Acesse a pasta de [Evidências](https://github.com/Kalyo-silva/trabalho03-cloud-shell/tree/main/evidencias).

# Dockerhub

Imagem disponível no [DockerHub](https://hub.docker.com/repository/docker/kalyo/trabalho03-cloud-shell-app/general)

# uso de IA no Projeto

Para este projeto, a Inteligência artificial foi utilizada como **ferramenta de apoio** no desenvolvimento de scripts e como **ferramenta de aprendizagem** para a compreensão dos comandos executados. 

Para garantir a qualidade do trabalho desenvolvido, **todo código gerado por IA foi revisado e documentado manualmente**, ao mesmo tempo em que **testes foram realizados nos scripts para confirmar sua execução conforme o esperado pela entrega desta atividade.**

# Dificuldades encontradas

A principal dificuldade que foi encontrada no desenvolvimento deste projeto foi a falta de conhecimento sobre os comandos necessários para as funcionalidades desenvolvidas. Agora, com o projeto finalizado, Conheço muito mais comandos úteis para realizar automações poderosas dentro do ambiente linux.