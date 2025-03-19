FactoryBot.define do
  factory :transaction_type do
    code { 1 }
    description { "Venda" }
    nature { "Entrada" }
    sign { "+" }
  end
end
