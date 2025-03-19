class UploadsController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def create
    if params[:file].present?
      # processa o arquivo CNAB utilizando o service
      result = ProcessCnabService.new(params[:file]).process_file

      if result[:success]
        redirect_to root_path, notice: "Arquivo processado com sucesso!"
      else
        p "Erro no processamento: #{result[:error]}"
        flash[:alert] = result[:error]
        render :new
      end
    else
      flash[:alert] = "Por favor, selecione um arquivo."
      render :new
    end
  end

  def index
    transactions = Transaction.joins(:transaction_type)

    @transactions = transactions.page(params[:page]).per(11)

    if params[:sort].present? && params[:direction].present?
      @transactions = @transactions.order("#{params[:sort]} #{params[:direction]}")
    else
      @transactions = @transactions.order(date: :desc)
    end

    transactions_by_store = Transaction.all.group_by(&:store_name)

    @store_totals = transactions_by_store.map do |store_name, transactions|
      total_balance = transactions.sum(&:value)
      { store_name: store_name, total_balance: total_balance }
    end
  end

end
