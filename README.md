* Ruby version

3.3.0

* System dependencies

Foram instaladas apenas duas gems, Kaminari para paginação e Rspec para testes

* Inicializar o projeto

docker compose up -d --build

* Rodar migrações para o banco de dados e seeds para criação dos tipos de transação

docker compose exec web bash -c "rails db:migrate && rails db:seed"

* Como rodar os testes direto no container?

docker compose exec web bash -c "rspec ./spec"


### Sobre a arquitetura


