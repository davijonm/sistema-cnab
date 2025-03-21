# Desafio Dev - Processador de Arquivos CNAB

Este projeto é uma aplicação Ruby on Rails para processar arquivos CNAB, armazenar transações e exibir de forma organizada. 

## Tecnologias Utilizadas
- Ruby 3.3.0
- Rails 8.0
- PostgreSQL 13.4
- Docker & Docker Compose
- RSpec (para testes)
- Kaminari (para paginação)
- Devise (para autenticação)
- Better Erros (para debug)

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

### 4. Rodar as migrações e seeds para popular a tabela de TransactionTypes e Users
```sh
docker compose exec web rails db:migrate db:seed
```

### 5. Rodar os testes
```sh
docker compose exec web rspec ./spec
```

## Como Utilizar

### **1. Faça Login**
- Acesse `http://localhost:3000/users/sign_in`
- Faça o login com o email que já foi criado anteriormente pelo seeds: "bycoders@exemplo.com" e senha "senha1234"

### **2. Upload de Arquivo CNAB**
- Faça o upload do arquivo CNAB (ele está dentro do repo neste diretório: spec/fixtures/files/CNAB.txt)
- As transações serão processadas e armazenadas no banco de dados

### **3. Visualização de Transações**
- As transações são listadas, podendo ser ordenadas por data, tipo de transação, hora, valor...

## Arquitetura

Utilizei POO na criação do service que faz o processamento do arquivo;
Criei testes unitarios para o service, controller e model user;
Usei a gem devise para fazer a autenticação;
Utilizei um callback no transactions_controller para garantir que as operações só serão realizadas mediante autenticação;

## Considerações Finais

A aplicação foi escrita usando o formato completo do rails (sem a flag --api), portanto os controllers não respondem no formato json, respondem um template a ser renderizado após a requisição. Optei por fazer desta forma para ter um frontend já integrado com o rails e ter mais velocidade e dinamismo na entrega.

Obviamente eu poderia ter feito método index do transactions_controller, assim:

render json: { transactions: @transactions, store_totals: @store_totals }

Entregaria um json para a requisição curl -H "Accept: application/json" -H "http://localhost:3000/transactions", 
mas tiraria o propósito das views do rails.

Um exemplo de documentação da API para este cenário onde eu retorno um json nos métodos index do transactions_controller, seria este:

### **1. Listar todas as transações**
```http
GET /transactions/
```
**Exemplo de resposta:**
```json
[
  {
    "id": 1,
    "store_name": "Loja Exemplo",
    "transaction_type": "Venda",
    "value": 150.00,
    "date": "2024-03-19T12:00:00Z"
  },
  {
    "id": 2,
    "store_name": "Mercado XPTO",
    "transaction_type": "Saque",
    "value": -200.00,
    "date": "2024-03-19T14:30:00Z"
  }
]
```

### **2. Filtrar transações por loja**
```http
GET /transactions?store_name=Loja%20Exemplo
```

### **3. Paginação**
Os resultados podem ser paginados usando os parâmetros `page` e `per_page`.
```http
GET /transactions?page=2&per_page=10
```


