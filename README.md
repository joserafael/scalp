# Scalp Trading

Uma aplicação Ruby on Rails para gerenciamento de operações de scalp trading de criptomoedas.

## Funcionalidades

-  Dashboard com estatísticas de trading
-  Gerenciamento de operações de compra e venda
-  Sistema de usuários
-  Pareamento automático de operações
-  Visualização de lucros e estatísticas
-  Suporte a múltiplas criptomoedas

## Pré-requisitos

Antes de instalar, certifique-se de ter os seguintes softwares instalados:

- **Ruby** 3.3.0 ou superior
- **Rails** 8.0.2.1 ou superior
- **Docker e Docker Compose**

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/joserafaelcamejo/scalp.git
cd scalp
```

### 2. Configure a versão do Ruby

O projeto usa Ruby 3.3.0. Se você usa rbenv:

```bash
rbenv install 3.3.0
rbenv local 3.3.0
```

### 3. Instale as dependências

```bash
# Instalar gems do Ruby
bundle install


```

### 4. Configure o banco de dados com Docker

#### 4.1. Inicie o PostgreSQL com Docker Compose

```bash
docker-compose up -d
```

Este comando irá:
- Baixar e iniciar um container PostgreSQL
- Configurar automaticamente o banco de dados
- Expor o PostgreSQL na porta 5432

#### 4.2. Verifique se o container está rodando

```bash
docker-compose ps
```

#### 4.3. Configure o arquivo database.yml

O arquivo `config/database.yml` já está configurado para usar o PostgreSQL do Docker:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: postgres
  password: postgres
  host: localhost

development:
  <<: *default
  database: scalp_development

test:
  <<: *default
  database: scalp_test

production:
  <<: *default
  database: scalp_production
  username: scalp
  password: <%= ENV['SCALP_DATABASE_PASSWORD'] %>
```

### 5. Configure o banco de dados

```bash
# Criar os bancos de dados
rails db:create

# Executar as migrações
rails db:migrate

# Popular com dados de exemplo 
rails db:seed
```

### 6. Inicie o servidor

```bash
rails server
```

A aplicação estará disponível em: http://localhost:3000

**Para parar os serviços:**
```bash
# Parar apenas o Rails
Ctrl+C

# Parar o PostgreSQL (Docker)
docker-compose down
```

## Uso

### Acessando a aplicação

1. **Dashboard**: http://localhost:3000 - Visão geral das operações
2. **Operações**: http://localhost:3000/trades - Lista todas as operações
3. **Nova Operação**: http://localhost:3000/trades/new - Criar nova operação
4. **Usuários**: http://localhost:3000/users - Lista de usuários e suas operações

### Criando operações

1. Acesse "Nova Operação" no menu
2. Selecione a criptomoeda
3. Escolha o tipo (compra ou venda)
4. Informe quantidade e preço unitário
5. O valor total será calculado automaticamente
6. Clique em "Criar Operação"

### Sistema de pareamento

O sistema automaticamente pareia operações de compra e venda:
- Operações de compra são pareadas com operações de venda
- O pareamento considera preços compatíveis para lucro
- Operações pareadas mostram o lucro obtido

## Desenvolvimento

### Executando testes

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/
bundle exec rspec spec/controllers/
```

### Estrutura do projeto

```
app/
├── controllers/     # Controladores da aplicação
├── models/         # Modelos de dados
├── views/          # Templates das páginas
├── services/       # Serviços de negócio
db/
├── migrate/        # Migrações do banco
├── seeds.rb        # Dados iniciais
spec/               # Testes RSpec
```

### Modelos principais

- **User**: Usuários do sistema
- **Cryptocurrency**: Criptomoedas disponíveis
- **Trade**: Operações de compra/venda
- **TradePair**: Pareamentos de operações

## Comandos úteis

```bash
# Gerenciar containers Docker
docker-compose up -d          # Iniciar em background
docker-compose down            # Parar containers
docker-compose logs -f         # Ver logs em tempo real

# Resetar banco de dados
rails db:drop db:create db:migrate db:seed

# Acessar console do Rails
rails console

# Console do PostgreSQL
docker-compose exec db psql -U postgres -d scalp_development

# Verificar rotas
rails routes

# Executar linter
rubocop

# Verificar segurança
brakeman
```

## Troubleshooting

### Erro de conexão com PostgreSQL (Docker)

```bash
# Verificar status dos containers
docker-compose ps

# Ver logs do PostgreSQL
docker-compose logs db

# Reiniciar PostgreSQL
docker-compose restart db

# Recriar containers (apaga dados!)
docker-compose down -v
docker-compose up -d
```

### Erro de conexão ao banco

```bash
# Verificar se o PostgreSQL está acessível
docker-compose exec db psql -U postgres -d scalp_development

# Recriar banco de dados
rails db:drop db:create db:migrate db:seed
```

### Erro de gems

```bash
# Limpar cache e reinstalar
bundle clean --force
bundle install
```

