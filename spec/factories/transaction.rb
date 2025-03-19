FactoryBot.define do
  factory :transaction do
    association :transaction_type
    date { Date.today }
    value { 100.0 }
    cpf { "12345678901" }
    card { "123456789012" }
    time { "120000" }
    store_owner { "Owner" }
    store_name { "Loja A" }
  end
end
