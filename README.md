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

## 1. terraform plan

``` shell
terraform plan
```

``` shell
terraform plan -destroy
```

## 2. terraform apply

``` shell
terraform apply -auto-approve
```

## 3. terraform destroy

``` shell
terraform destroy
```

## 4. terraform state

## 5. terraform fmt

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

Importante ressaltar que esse comanda não valida/corrige possíves erros de sintaxe. Para isso veja o [comando abaixo](#terraform-validate).

## 6. terraform validate {#terraform-validate}

O comando **terraform validate** vai verificar se algum arquivo do repositório está com algum erro de sintaxe

``` shell
terraform validate
```

Vale também adicionar esse comando no arquivo de **pre-commit**

## 7. terraform console [WIP]

Assim como em uma linguagem de programação, é possível testar como "as coisas funcionam" no terraform usando

``` shell
terrform console
```

Usando, por exemplo, a função **cidrsubnet**  

# Algumas Tricks para melhorar a expirência com o terraform

## 

## Variables

Esse tópico é muito importante para que você tenha fluidez no desenvolvimento do seu código terraform.
Como o próprio nome diz, são variáveis que, assim como em qualquer linguagem de programação, você usará em diversos arquivos.

Um exemplo é, quando você cria um bucket e precisa referência-lo em diversos outros recursos, como por exemplos os scripts do seu glue job.

[Para saber mais veja a documentação oficial no site da terraform](https://developer.hashicorp.com/terraform/language/values/variables)

Continuando nosso trabalho, para utilizar variáveis no seu projeto, crie um arquivo com nome ao seu gosto (você pode chama-lo de **variables.tf** para ficar mais intuitivo) e declare da seguinte maneira:

```tf
variable "name-bucket-script-glue-job" {
  type    = string
  default = "bucket-para-meus-scripts-glue-job"
}
```

Um ponto de atenção é que ao usar o parâmetro _Default_  caso a variável não seja, de fato, declarada o argumento do _Default_ será utilizado no lugar.

Dessa forma, você terá uma variável chamada **bucket-script-glue-job** que poderá ser chamada/invocada em qualquer outro recurso que esteja criando dentro da sua arquitetura.

O próximo passo é usar a sua variável, então ao construir um recruso, como um bucket, você poderá adicionar a variável _bucket-script-glue-job_ dentro do recurso, como segue:


```
resource "aws_s3_bucket" "terraform_for_data_engineer_s3" {
  bucket = var.name-bucket-script-glue-job

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```
Perceba que toda vez que você executar o terraform apply ou plan será necessário atribuir o valor da variável. Isso pode ser um problema se você tiver muitas variáveis.

Para que isso não aconteça, adicionamos o arquivo terraform.tfvars onde nele poderá ser colocado todos os valores para as suas variáveis.

Perceba que esse arquivo não é rastreado pelo git.

Ao criar o arquivo terraform.tfvars, basta apenas declarar o valor das suas variáveis.

```tf
name_bucket_script_glue_job = "scripts-for-glue"
```

Agora na sua variável será injetado o valor "scripts-for-glue" automáticamente. Bacana, né?

## Tags padrões com o locals

Sabe aquelas tag's que padrões que são exigidas pela sua empresa para rastreio dos custos? Então, é possível torná-las padrão e referenciar de maneira fácil e rápida em todos os recursos que você está construindo.Com o locals

## Migrando o backend tfstate

Percebe que após dar o primeiro **terraform apply** é adicionado um arquivo chamado terraform.tfstate.backup.
Não é recomendado deixar esse arquivo no repositório local pois dificulta o gerenciamento da equipe acerca das modificações realizadas e pensando em um contexto empresarial esse arquivo é extremamente crítico para a empresa.

Dessa forma, se faz necessário a migração desse arquivo para um repositório (ou backend) remoto. [Você pode clicar aqui para saber mais](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)

Já que o objeto de estudo envolve componentes da aws, usaremos como backend um bucket s3.

## Terraform Functions

## Modulos em Terraform

Módulos são para o terraform assim como funções são para linguagens de programação.
A ideia é desacoplar o código com input --> processamento --> saída

Por exemplo, em um projeto de engenharia de dados, podemos ter os seguintes agrupamentos:

- Network
- s3
- Glue
- EMR
- Lambda
- Redshift

Isso possibilita

- Manutenção;
- A infra vira um Produto/Serviço e;
- Isolamento.

Para isso crie um diretório **modules** e dentro de modules crie outro diretório com o nome do seu modulo, por exemplo, **network**

Na raiz do projeto, crie um arquivo modules.tf e faça

```tf
module "data_engineer_network" {
    source = "./modules/network"
}
```
Sempre que configurar um módulo, dê o comando 

```tf
terraform init
```
Output do module:

Quais informações você precisa jogar para fora do seu módulo para que sejam usados pelos outros módulos?

Por exemplo, o name/arn da role que o glue usará:

Para isso, dentro do seu módulo crie um arquivo chamado **output.tf** com o seguinte padrão:

```tf
output "name_do_output" {
    value = aws_iam_role.terraform_for_data_engineer_role.arn
}
```

Pronto! Dessa forma o seu módulo iam entregará para ser usado em qualquer outro módulo a role criada. Isso também serve para debugar e enteder o que está acontecendo na sua infraestrutura.

Para ter o output no seu terminal e ajudar no debug/visualização dos atributos do recurso, basta criar o mesmo arquivo **output.tf** só que na raíz do seu projeto.

Uma observação interessante é que o arquivo de configuração do(s) _provider(s)_ devem ficar na raiz do projeto.

 [Saiba mais lendo a documentação oficial](https://developer.hashicorp.com/terraform/language/modules/develop)
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

``` tf
resource "aws_s3_bucket" "terraform_for_data_engineer_s3" {
  bucket = "scripts-for-glue"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
s3.tf
```

Mas como engenheiro de dados, precisaremos que os scripts criados no repositório, arquivos de apoio e/ou até mesmo arquivos com dados estejam também no bucket.
Conseguimos fazer isso diretamente via terraform com o recurso **aws_s3_object** conforme abaixo:

``` tf
resource "aws_s3_object" "upload_arquivos" {
  bucket = aws_s3_bucket.terraform_for_data_engineer_s3.id

  for_each = fileset("app/src", "**/*.*")

  key          = each.value
  source       = "app/src/${each.value}"
  content_type = each.value
}
s3.tf
```

## Policies & Roles

Como uma breve introdução ao serviço de IAM, tudo o que usuários ou recursos fazem dentro da aws é necessário permissões previamente concedidas.
Como exemplo em nossa arquitetura, o aws glue precisará de acesso para interagir com o bucket s3, com o catalogo e assim por diante.
Diante desse contexto, a aws já provisiona uma policy gerenciada por ela mesmo (as chamadas **_aws managed policy_** ) que para o caso do glue é a _AWSGlueServiceRole_.

Então o fluxo para dar permissões a recursos e a usuáirios/grupos é:

--> Criar a policy --> criar a role --> attachar a policy a role

Como já temos a policy, vamos criar um arquivo chamado **iam.tf** onde criaremos a role e anexaremos a policy a role para que o glue possa exercer corretamente a sua função. 

``` tf
resource "aws_iam_role" "terraform_for_data_engineer_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "attach_role_glue" {
  role       = aws_iam_role.terraform_for_data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}
iam.tf
```

## Glue

Com as configurações de bucket e subida dos arquivos necessários juntamente com as roles, já podemos partir para a criação, de fato, do glue job.

### Glue Job

### Glue Database

### Glue Table

### Glue Workflow

### Glue Trigger

## Lambda
