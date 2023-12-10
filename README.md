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

``` shell
terraform -version
```

Assim que estiver no seu repositório onde vai trabalhar os arquivos **.tf** basta executar

``` shell
terraform init
```

Para iniciar o backend do terraform

OBS.: Ao iniciar o repositório você pode utilizar o **.gitignore** do terraform para iginorar arquivos que não são boa prática versionar.

Seguindo a premissa acima, adicione dentro do **.gitignore** o arquivo oculto **.terraform.lock.hcl**

## AWS CLI

1. Baixar o aws _command line interface_ (cli): Basta buscar por _Download aws cli_ e seguir as instruções da página oficial da aws

OBS.: Instalar a versão >= 2.

Para instalar no linux cli o comando será similar a

``` shell
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

2. Criar usuário [WIP]

3. Configurar credenciais

Com um usuário pronto e com a _Access Key_ e a _Security Key_ em mãos, basta dar o comando:

``` shell
aws configure
```

E preencher os itens necessários conforme abaixo

``` shell
AWS Access Key ID [None]: "SUA_ACCESS_KEY"
AWS Secret Access Key [None]: "SUA_SERCRET_KEY"
Default region name [None]: "SUA_REGIAO_PREFERENCIA" 
Default output format [None]: 
```
Para a _region_, recomenda-se usar us-east-1 ou us-east-2 por conta de custo
Logo após a configuração, para validar que os dados estão corretos, você pode usar o comando:

``` shell
aws sts get-caller-identity
```


E a saída será algo parecido com isso

``` shell
{
    "UserId": "SEU_USUARIO",
    "Account": "SUA_CONTA",
    "Arn": "SEU_USER_ARN"
}

```
Pronto, com isso sua cli está configurada para interagir com recursos da aws e consequentemente o terraform irá usar a cli para provisionar os recursos daqui pra frente.


# Principais comandos Terraform

1. terraform plan

## Migrando o backend tfstate

Percebe que após dar o primeiro **terraform apply** é adicionado um arquivo chamado terraform.tfstate.backup.
Não é recomendado deixar esse arquivo no repositório local pois dificulta o gerenciamento da equipe acerca das modificações realizadas e pensando em um contexto empresarial esse arquivo é extremamente crítico para a empresa.

Dessa forma, se faz necessário a migração desse arquivo para um repositório (ou backend) remoto. [Você pode clicar aqui para saber mais](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)

Já que o objeto de estudo envolve componentes da aws, usaremos como backend um bucket s3.



2. terraform apply

3. terraform destroy

4. terraform state

5. terraform fmt

É uma boa prática manter um padrão com os arquivos **.tf**, ou seja, utilizar um padrão de lint para que o código escrito fique dentro das boas práticas do terraform, inclusive, em algumas pipelines pode haver uma etapa de lint e caso o código esteja mal formatado o pipe quebra.

Para verificar o lint dos arquivos **.tf** você pode executar o comando para checar se existem algum problema com os seus arquivos terraform

``` shell
terraform fmt -recursive -check
```

A saída dsse comando, mostrará (caso existam) os arquivos mal formatados.

Felizmente o terraform já formata os seus arquivos por padrão usando o comando

``` shell
terraform fmt -recursive
```

Observe que os arquivos antes mal formatados ganham a formatação que o terraform considera mais ideal.

# Pre commit

Imagine que ao submeter seu código para o repositório remoto e ao iniciar a _pipe_ por algum motivo a sua _pipe_ quebra e você percebe que cometeu algum erro de sintaxe ou esqueceu de fazer algum ajuste de lint. Logo, você vai ter que voltar no seu editor de texto e arrumar onde a _pipe_ reclamou.

Chato não é mesmo?

Felizmente, exite uma ferramenta que possibilita verificações de (praticamente) todas as verificações que sua _pipe_ pode fazer, essa ferramenta é o [**pre commit**](https://pre-commit.com/).

Tendo como premissa que você já instalou o pacote (é só dar um pip install), crie um arquivo oculto chamado  .pre-commit-config.yaml.

O próximo passo é  buscar os hooks que precisaremos para o terraform. Nesse caso [estou usando esse repo](https://github.com/antonbabenko/pre-commit-terraform) para adicionar as configurações do terraform.

A configuração do arquivo para executar o fmt, ficou assim

``` yaml
repos:
-   repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.83.6
    hooks:
    - id: terraform_fmt
      args:
        - --args=-recursive
```
Antes da mágica acontecer é necessário você adicionar para a área de staging do git o arquivo _.pre-commit-config.yaml._. Faça:

``` shell
git add .pre-commit-config.yaml.
```

Perceba que a partir de agora ao dar o _commit_ (você pode modificar a identação de algum arquivo **.tf**) o **pre-commit** se encarregara de executar o comando

``` shell
terraform fmt -recursive
```

Show não é mesmo?

Como o arquivo foi modificado, é necessário você adicionar o arquivo para a área de staging e fazer o _commit_.

# Criando os recursos

## VPC

## Subnets

## Bucket

## Policies

## Role

## Glue

### Glue Database

### Glue Table

### Glue Job

### Glue Workflow

### Glue Trigger

## Lambda
