class TransactionSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :value, :date, :cpf, :card, :time, :store_name, :store_owner

  belongs_to :transaction_type
end
