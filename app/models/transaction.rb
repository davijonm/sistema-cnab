class Transaction < ApplicationRecord
  belongs_to :transaction_type

  validates :date, :value, :cpf, :card, :store_owner, :store_name, presence: true
  validates :value, numericality: true
end
