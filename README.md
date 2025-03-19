# Desafio Dev - Processador de Arquivos CNAB

Este projeto é uma aplicação Ruby on Rails para processar arquivos CNAB, armazenar transações e exibir de forma organizada. Além da interface web, a aplicação expõe um endpoint de API para consulta das transações.

## Tecnologias Utilizadas
- Ruby on Rails
- PostgreSQL
- Docker & Docker Compose
- RSpec (para testes)
- Kaminari (para paginação)

## Setup do Projeto

### 1. Pré-requisitos
- Docker e Docker Compose instalados

### 2. Clonar o repositório
```sh
git clone https://github.com/davijonm/desafio-dev.git
cd desafio-dev
```

### 3. Subir os containers
```sh
docker compose up -d --build
```

### 4. Criar o banco de dados e rodar as migrações
```sh
docker compose exec web rails db:migrate db:seed
```

### 5. Rodar os testes
```sh
docker compose exec web rspec ./spec
```

## Como Utilizar

### **2. Upload de Arquivo CNAB**
- Acesse `http://localhost:3000/users/sign_in`
- Faça o login com o email já criado pelo seeds: "bycoders@exemplo.com" e senha "senha123"

### **2. Upload de Arquivo CNAB**
- Faça o upload do arquivo CNAB
- As transações serão processadas e armazenadas no banco de dados

### **3. Visualização de Transações**
- As transações são listadas, podendo ser ordenadas por data, tipo de transação, hora, valor...
