class UploadsController < ApplicationController
  def new
  end

  def create
    if params[:file].present?
      # processa o arquivo CNAB
      result = process_cnab_file(params[:file])
      if result[:success]
        redirect_to root_path, notice: "Arquivo processado com sucesso!"
      else
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


  private

  def process_cnab_file(file)
    # processa o arquivo e salva as transações
    begin
      File.open(file.path, "r") do |f|
        f.each_line do |line|
          # para cada linha do arquivo, vamos extrair os dados e salvar no banco
          transaction = parse_cnab_line(line)
          transaction.save if transaction.valid?
        end
      end
      { success: true }
    rescue => e
      { success: false, error: "Erro ao processar o arquivo: #{e.message}" }
    end
  end

  def parse_cnab_line(line)
    tipo = line[0..0].to_i
    data = line[1..8]
    valor = line[9..18].to_f / 100.0
    cpf = line[19..29]
    cartao = line[30..41]
    hora = line[42..47]
    dono_loja = line[48..61]
    nome_loja = line[62..80]

    transaction_type = TransactionType.find_by(code: tipo)

    Transaction.new(
      transaction_type: transaction_type,
      date: Date.strptime(data, "%d%m%Y"),
      value: valor,
      cpf: cpf,
      card: cartao,
      time: hora,
      store_owner: dono_loja.strip,
      store_name: nome_loja.strip
    )
  end
end
