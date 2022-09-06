Coloque aqui suas respostas, observações e o que mais achar necessário. Mais uma vez, boa sorte!


#### 1. Deploy da aplicação na AWS.
 
O deploy da aplicacao vai ocorrer de maneira simples, com uma instância EC2-micro criada, com o docker e docker-compose previamente instalados basta clonar o repositorio https://github.com/vasppipoka/devops_test, entrar no diretorio criado após o clone e executar o docker-compose.
 
Comandos:
 
git clone https://github.com/vasppipoka/devops_test
cd ../devops test
docker-compose up -d
 
 
#### 2. Crie uma forma que possamos subir essa aplicação localmente de forma simples.
 
A aplicação go ninja foi idealizada em docker com variáveis de ambiente para que possa ser utilizada para ser escalada ou customizada e possa ser executada de maneira simples utilizando docker-compose.
 
Irei explicar o arquivo dockerfile linha por linha.
 
Basicamente o dockerfile realiza a criação do container usando como base a imagem já disponível do golang, que já contém tudo que é necessário para a execução de códigos escritos em GO.
 
 - FROM golang:1.19.0-bullseye
 
Declarei a variável de ambiente APPNAME go ninja para ser utilizada no processo de execução abaixo.
 
- ENV APP NAME go_ninja
 
Declarei a variável repo como repositório base do código para utilização no container, que pode ser alterada conforme a necessidade do projeto.
 
 - ENV repo https://github.com/vasppipoka/devops_test
 
Primeiro comando de execução para criação de um diretório dentro do container, que utiliza a variável APPNAME declarada acima.
 
 - RUN mkdir /${APPNAME}
 
Segundo comando de execução realiza o clone do repositório hospedado no github utilizando a variável declarada acima, clonando os arquivos para a pasta criada no passo anterior.
 
 - RUN git clone ${repo} /${APPNAME}
 
Terceiro comando executa o permissionamento full da pasta para não ocorrer erros de execução (Podemos utilizar um nível de permissionamento mais restritivo para evitar possíveis problemas de segurança.)
 
 - RUN chmod 777 /${APPNAME}
 
Declaro que o diretório de trabalho do container será o diretório criado com a variável declarada no início do dockerfile
 
 - WORKDIR /${APPNAME}
 
Quarto comando de execução que inicializa o modulo app usado para execucao do projeto
 
 - RUN go mod init app
 
O Quinto comando de execução realiza o download de todas as dependências necessárias para execução do projeto ("github.com/gorilla/mux") citada no arquivo main.go do projeto.
 
 - RUN go mod tidy
 
O sexto comando de execução realiza o build do nosso projeto que está dentro do diretório de trabalho.
 
 - RUN go build -o main .
 
Declaro que a porta 8000 do container será exposta para conseguir consumir a API em execução.
 
 - EXPOSE 8000
 
Por último o CMD que irá executar o GO e executar a nossa aplicação.
 
 - CMD ["/go_ninja/main"]
 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
Com o arquivo dockerfile construído, realizei a criação do arquivo docker-compose.yaml para o deploy da aplicação, utilizando o docker compose.
 
Com ele podemos escalar a aplicação ou reduzir o número de containers conforme a necessidade.
 
O arquivo é composto pelas linhas abaixo
 
 - version: "3.8"
 
Versão do arquivo docker composto que será utilizado.
 
 - services:
 
Serviços que serão criados e declarados abaixo, que podem ser adicionados ou removidos conforme a necessidade.
 
 - ninja:
 
Declarado o nome do serviço que será executado
 
 - build: .
 
Informa ao docker compose construir a imagem docker com base no dockerfile que está dentro do diretório de execução
 
 - image: vasp pipoka/go ninja
 
Nome da imagem que será criada a partir do dockerfile.
 
 - container_name: go_ninja
 
Nome do container que será criado a partir da imagem criada no passo anterior
 
 - restart: always
 
Informa ao docker para sempre reiniciar o container caso ele pare de executar a aplicação
 
 
 -ports:    - "8000:8000"
 
Expõe a porta 8000 do container para a rede externa que está executando o docker.
 
Com isso o arquivo está completo e para ser executado basta rodar o comando abaixo
 
 - docker-compose up -d
 
Após sua execução podemos notar que a imagem (vasp pipoka/go ninja) foi criada, o container (go ninja) foi criado e já está em execução, permitindo o consumo da api utilizando o endereço IP do servidor hospedeiro + porta e o diretório que está o codigo /health check
 
#### 3. Coloque esta aplicação em um fluxo de CI que realize teste neste código.
 
Realizei a criação de um fluxo CI que realiza o build e testa o código utilizando a ferramenta de CI CIRCLECI, onde ela está conectada ao repositório do projeto no github e ao realizar um commit ela executa os passos de build do código e também o teste utilizando o código main test.go fornecido no projeto.
 
O fluxo realiza todo o processo de criação do container e execução do código dentro da infraestrutura da plataforma do circleCI como pode ser visto nos arquivos do projeto com o arquivo circleci/config.yml
 
A validação do commit pode ser vista diretamente no diretório do github ou no link abaixo
 
https://app.circleci.com/pipelines/github/vasppipoka/devops_test
 
 
 
#### 4. Altere o nome da aplicação.
 
Para alterar o nome da aplicação basta ir até a linha 19 do arquivo main.go e alterar a variável "APP_NAME" no caso ela foi alterada de ninja para master.
 
  appname := getEnv("APP_NAME", "master")
 
A aplicação foi construída de forma que se houver alguma alteração no código basta remover o container que esta executando e também a sua imagem, pois quando o docker-compose for executado novamente o novo container já irá subir com a alteração realizada, testada e aprovada pelos testes de CI.
 
 
 
#### 5. Discorra qual (ou quais) processos você adotaria para garantir uma entrega contínua desta aplicação, desde o desenvolvimento, até a produção.
 
Acredito que para uma entrega contínua desta aplicação deve ser criado através de uma esteira de desenvolvimento, para que as equipes possam acompanhar e testar a aplicação desde o momento da sua criação até a sua entrega.
 
Utilizando ferramentas de automação e integração que validem o código de forma que se houver algum erro durante o processo de desenvolvimento ele seja devidamente identificado e corrigido antes de ser entregue.
 
Durante a execução deste projeto identifiquei alguns gap`s que podem ser corrigidos a fim de melhorar o seu processo de desenvolvimento e entrega, seja criando mais branches para teste e desenvolvimento e integrando o processo de commit do código com a criação da imagem docker, evitando assim erros de versionamento e disparidade entre as imagens utilizadas.




