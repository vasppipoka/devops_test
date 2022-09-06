Coloque aqui suas respostas, observações e o que mais achar necessário. Mais uma vez, boa sorte!


#### 1. Deploy da aplicação na AWS.

O deploy da aplicacao vai ocorrer de maneira simples, com uma instancia EC2-micro criada, com o docker e docker-compose previamente instalados basta clonar o repositorio https://github.com/vasppipoka/devops_test, entrar no diretorio criado apos o clone e executar o docker-compose.

Comandos: 

git clone https://github.com/vasppipoka/devops_test
cd ../devops_test
docker-compose up -d 


#### 2. Crie uma forma que possamos subir essa aplicação localmente de forma simples.

A aplicacao go_ninja foi idealizada em docker com variaveis de ambiente para que possa ser utilizada para ser escalada ou customizada e possa ser executada de maneira simples utilizando docker-compose.

Irei explicar o arquivo dockerfile linha por linha. 

Basicamente o dockerfile realiza a criacao do container usando como base a imagem ja disponivel do golang, que ja contem tudo que e necessario para a execucao de codigos escritos em GO.

## - FROM golang:1.19.0-bullseye

Declarei a variavel de ambiente APPNAME go_ninja para ser utilizada no processo de execucao abaixo. 

## - ENV APPNAME go_ninja

Declarei a variavel repo como repositorio base do codigo para utilizacao no container, que pode ser alterada conforme a necessidade do projeto.

## - ENV repo https://github.com/vasppipoka/devops_test

Primeiro comando de execucao para criacao de um diretorio dentro do container, que utiliza a variavel APPNAME declarada acima. 

## - RUN mkdir /${APPNAME}

Segundo comando de execucao realiza o clone do repositorio hospedado no github utilizando a variavel declarada acima, clonando os arquivos para a pasta criada no passo anterior. 

## - RUN git clone ${repo} /${APPNAME}

Terceiro comando executa o permissionamento full da pasta para nao ocorrer erros de execucao (Podemos utilizar um nivel de permissionamento mais restritivo para evitar possiveis problemas de seguranca.)

## - RUN chmod 777 /${APPNAME}

Declaro que o diretorio de trabalho do container sera o diretorio criado com a variavel declarada no inicio do dockerfile

## - WORKDIR /${APPNAME}

Quarto comando de execucao que inicializa o modulo app usado para execucao do projeto

## - RUN go mod init app

Quinto comando de execucao realiza o download de todas as dependencias necessarias para execucao do projeto ("github.com/gorilla/mux") citada no arquivo main.go do projeto.

## - RUN go mod tidy

Sexto comando de execucao realiza o build do nosso projeto que esta dentro do diretorio de trabalho. 

## - RUN go build -o main .

Declaro que a porta 8000 do container sera exposta para conseguir consumir a API em execucao. 

## - EXPOSE 8000

Por ultimo o CMD que ira executar o GO e executar a nossa aplicacao. 

## - CMD ["/go_ninja/main"]

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Com o arquivo dockerfile construido, realizei a criacao do arquivo docker-compose.yaml para o deploy da aplicacao, utilizando o docker compose. 

Com ele podemos escalar a aplicacao ou reduzir o numero de containers conforme a necessidade.

O arquivo e composto pelas linhas abaixo

## - version: "3.8"

Versao do arquivo docker compose que sera utilizada.

## - services:

Servicos que serao criados e declarados abaixo, que podem ser adicionados ou removidos conforme a necessidade.

## - ninja:

Declarado o nome do servico que sera executado

## - build: .

Informa ao dockercompose construir a imagem docker com base no dockerfile que esta dentro do diretorio de execucao 

## - image: vasppipoka/go_ninja

Nome da imagem que sera criada a partir do dockerfile.

## - container_name: go_ninja

Nome do container que sera criado a partir da imagem criada no passo anterior

## - restart: always

Informa ao docker para sempre reiniciar o container caso ele pare de executar a aplicacao


## -ports:    - "8000:8000"

Expoe a porta 8000 do container para a rede externa que esta executando o docker. 

Com isso o arquivo esta completo e para ser executado basta rodar o comando abaixo

## - docker-compose up -d 

Apos sua execucao podemos notar que a imagem (vasppipoka/go_ninja) foi criada, o container (go_ninja) foi criado e ja esta em execucao, permitindo o consumo da api utilizando o endereco IP do servidor hospedeiro + porta e o diretorio que esta o codigo /healthcheck 

#### 3. Coloque esta aplicação em um fluxo de CI que realize teste neste código.

Realizei a criacao de um fluxo CI que realiza o build e testa o codigo utilizando a ferramenta de CI CIRCLECI, onde ela esta conectada ao repositorio do projeto no github e ao realizar um commit ela executa os passos de build do codigo e tambem o teste utilizando o codigo main_test.go fornecido no projeto. 

O fluxo realiza todo o processo de criacao do container e execucao do codigo dentro da infraestrutura da plataforma do circleCI como pode ser visto nos arquivos do projeto com o arquivo circleci/config.yml

A validacao do commit pode ser vista diretamente no diretorio do github ou no link abaixo

https://app.circleci.com/pipelines/github/vasppipoka/devops_test



#### 4. Altere o nome da aplicação.

Para alterar o nome da aplicacao basta ir ate a linha 19 do arquivo main.go e alterar a variavel "APP_NAME" no caso ela foi alterada de ninja para master.

  appname := getEnv("APP_NAME", "master")

Aplicacao foi construida de forma que se houver alguma alteracao no codigo basta remover o container que esta execucao e tambem a sua imagem, pois quando o docker-compose for executado novamente o novo container ja ira subir com a alteracao realizada, testada e aprovada pelos testes de CI.



#### 5. Discorra qual (ou quais) processos você adotaria para garantir uma entrega contínua desta aplicação, desde o desenvolvimento, até a produção.



