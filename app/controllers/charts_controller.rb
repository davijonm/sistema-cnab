class ChartsController < ApplicationController
  before_action :authenticate_user!

  def index
    # transacoes por mês
    @transactions_by_month = Transaction.group_by_month(:date).sum(:value)

    # total por loja
    @transactions_by_store = Transaction.group(:store_name).sum(:value)

    # tipo de transacao
    @transactions_by_type = Transaction.joins(:transaction_type)
                                       .group('transaction_types.description')
                                       .sum(:value)
  end
end
