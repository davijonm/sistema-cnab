# app/controllers/uploads_controller.rb
class UploadsController < ApplicationController
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
    @transactions = Transaction.all
  end
end
