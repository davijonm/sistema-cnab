class TransactionType < ApplicationRecord
  has_many :transactions

  validates :code, :description, :nature, :sign, presence: true

  def income?
    sign == '+'
  end

  def expense?
    sign == '-'
  end
end
