class Transaction < ApplicationRecord
  belongs_to :transaction_type

  validates :date, :value, :cpf, :card, :time, :store_owner, :store_name, presence: true
  validates :cpf, format: { with: /\A\d{11}\z/, message: "deve ter 11 dígitos" }
  validates :value, numericality: { greater_than: 0 }
end
