# terraform-for-data-engineers
Repository for AWS services used in a data engineer's day-to-day life

# Setup Inicial

## Instalação do Terraform

Para instalar o _client_ do terraform, basta pesquisar por *terraform download* no seu navegador de preferência, escolher o seu sistema operacional e versão e seguir o passo a passo mencionado na tela.

No meu caso estou usando o Linux Mint e instalei via gerenciador de pacotes, para ter acesso mais fácil em futuras atualizações. O comando dado no terminal foi 

``` shell
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

Para validar a instalção correta do terraform, você pode executar o comando abaixo:

```
terraform -version
```

Assim que estiver no seu repositório onde vai trabalhar os arquivos **.tf** basta executar

```
terraform init
```

Para iniciar o backend do terraform

OBS.: Ao iniciar o repositório você pode utilizar o **.gitignore** do terraform para iginorar arquivos que não são boa prática versionar.

Seguindo a premissa acima, adicione dentro do **.gitignore** o arquivo oculto **.terraform.lock.hcl**

## AWS CLI

1. Baixar o aws _command line interface_ (cli): Basta buscar por _Download aws cli_ e seguir as instruções da página oficial da aws

OBS.: Instalar a versão >= 2.

Para instalar no linux cli o comando será similar a

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

2. Criar usuário [WIP]

3. Configurar credenciais

Com um usuário pronto e com a _Access Key_ e a _Security Key_ em mãos, basta dar o comando:

```
aws configure
```

E preencher os itens necessários conforme abaixo

```
AWS Access Key ID [None]: "SUA_ACCESS_KEY"
AWS Secret Access Key [None]: "SUA_SERCRET_KEY"
Default region name [None]: "SUA_REGIAO_PREFERENCIA" 
Default output format [None]: 
```
Para a _region_, recomenda-se usar us-east-1 ou us-east-2 por conta de custo
Logo após a configuração, para validar que os dados estão corretos, você pode usar o comando:

```
aws sts get-caller-identity
```


E a saída será algo parecido com isso

```
{
    "UserId": "SEU_USUARIO",
    "Account": "SUA_CONTA",
    "Arn": "SEU_USER_ARN"
}

```
Pronto, com isso sua cli está configurada para interagir com recursos da aws e consequentemente o terraform irá usar a cli para provisionar os recursos daqui pra frente.

## Migrando o backend tfstate

# Criando os recursos

## Bucket

## Role

## Glue

### Glue Database

### Glue Table

### Glue Job

### Glue Workflow

### Glue Trigger

