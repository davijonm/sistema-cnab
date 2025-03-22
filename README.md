# Processador de Arquivos CNAB

Este projeto é uma aplicação Ruby on Rails para processar arquivos CNAB, armazenar transações e exibir de forma organizada. 

## Tecnologias Utilizadas
- Ruby 3.3.0
- Rails 8.0
- PostgreSQL 13.4
- Docker & Docker Compose
- RSpec (para testes)
- Kaminari (para paginação)
- Devise (para autenticação)
- FastJsonapi (para serialização da api)
- Better Erros (para debug)
- Turbo Stream (para fazer o carregamento parcial da página )

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
- Faça o upload do arquivo CNAB (ele está dentro do repo neste diretório: spec/fixtures/CNAB.txt)
- As transações serão processadas e armazenadas no banco de dados

### **3. Visualização de Transações**
- As transações são listadas, podendo ser ordenadas por data, tipo de transação, hora, valor...

## Arquitetura

- Utilizei POO na criação do service que faz o processamento do arquivo;
- Criei testes unitarios para o service, controller e model user;
- Criei testes de requisição para a API de exemplo;
- Utilizei a gem devise para fazer a autenticação;
- Utilizei o turbo stream para recarregamento parcial da pagina;
- Utilizei um callback no transactions_controller para garantir que as operações só serão realizadas mediante autenticação;

# Considerações

A aplicação foi escrita usando o formato completo do rails (sem a flag --api), portanto os controllers não respondem no formato json, respondem um template a ser renderizado após a requisição. Optei por fazer desta forma para ter um frontend já integrado com o rails e ter mais velocidade e dinamismo na entrega.

Para termos os dois cenários, criei de exemplo, um controller serializado (/app/controllers/api/v1/transactions_controller.rb) para funcionar como uma API REST. Basicamente ele faz a mesma coisa que o controller original (/app/controllers/transactions_controller.rb) mas serve para consultas, então não implementei autenticação nele.

## Documentação da API criada:

### **1. Listar todas as transações**
```http
GET api/v1/transactions
```

**Requisição:**
```http
curl "http://localhost:3000/api/v1/transactions"
```

**Resposta:**

```http
{
  "data": [
    {
      "id": "27",
      "type": "transaction",
      "attributes": {
        "id": 27,
        "value": "506.17",
        "date": "2019-06-01",
        "cpf": "84515254073",
        "card": "1234****2231",
        "time": "100000",
        "store_name": "MERCADO DA AVENIDA",
        "store_owner": "MARCOS PEREIRA"
      },
      "relationships": {
        "transaction_type": {
          "data": {
            "id": "4",
            "type": "transaction_type"
          }
        }
      }
    },
    {
      "id": "12",
      "type": "transaction",
      "attributes": {
        "id": 12,
        "value": "132.0",
        "date": "2019-03-01",
        "cpf": "55641815063",
        "card": "3123****7687",
        "time": "145607",
        "store_name": "LOJA DO Ó - MATRIZ",
        "store_owner": "MARIA JOSEFINA"
      },
      "relationships": {
        "transaction_type": {
          "data": {
            "id": "5",
            "type": "transaction_type"
          }
        }
      }
    }
  ]
}
```

### **2. Filtrar transações por id**
```http
GET api/v1/transactions/:id
```

**Requisição**
```http
curl "http://localhost:3000/api/v1/transactions/:id"
```

**Resposta**
```http
{
  "data": {
    "id": "12",
    "type": "transaction",
    "attributes": {
      "id": 12,
      "value": "132.0",
      "date": "2019-03-01",
      "cpf": "55641815063",
      "card": "3123****7687",
      "time": "145607",
      "store_name": "LOJA DO Ó - MATRIZ",
      "store_owner": "MARIA JOSEFINA"
    },
    "relationships": {
      "transaction_type": {
        "data": {
          "id": "5",
          "type": "transaction_type"
        }
      }
    }
  }
}
```

### **2. Processar um arquivo**

```http
POST /api/v1/transactions
```

**Processar um arquivo valido (a partir do diretório raiz do projeto, rode o comando abaixo)**
```http
curl -X POST -F "file=@spec/fixtures/CNAB.txt" http://localhost:3000/api/v1/transactions
```

**Resposta**
```http
{
	"message": "Arquivo processado com sucesso!"
}
```

**Processar um arquivo invalido (a partir do diretório raiz do projeto rode o comando abaixo)**
```http
curl -X POST -F "file=@spec/fixtures/INVALID_CNAB.txt" http://localhost:3000/api/v1/transactions
```

**Resposta**
```http
{
	"error": "Ops, há algo de errado com o arquivo."
}
```

**Quando nenhum arquivo é enviado (a partir do diretório raiz do projeto rode o comando abaixo)**
```http
curl -X POST -F "file=" http://localhost:3000/api/v1/transactions
```

**Resposta**
```http
{
	"error": "Por favor, selecione um arquivo."
}
```

### Futuras melhorias que poderiam ser implementadas conforme o crescimento do projeto

- Criação de roles para controle de acesso de partes do sistema
- Indexação de colunas importantes da tabela transactions para melhorar a performance (em caso de crescimento do banco de dados)
- Gráficos com insights sobre as transações
- Background jobs com Sidekiq por exemplo para o processamento do arquivo (considerando que houvessem muitas solicitações)