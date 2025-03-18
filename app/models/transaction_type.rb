class TransactionType < ApplicationRecord
  has_many :transactions

  validates :code, :description, :nature, :sign, presence: true
end
