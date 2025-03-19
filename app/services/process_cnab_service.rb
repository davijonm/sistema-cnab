class ProcessCnabService
  def initialize(file)
    @file = file
  end

  def process_file
    # processa o arquivo e salva as transações
    begin
      File.open(@file.path, "r") do |f|
        f.each_line do |line|
          # para cada linha do arquivo, vamos extrair os dados e salvar no banco
          transaction = parse_cnab_line(line)
          if transaction.valid?
            transaction.save
          else
            Rails.logger.error "Erro de validação na transação: #{transaction.errors.full_messages.join(', ')}"
          end
        end
      end
      { success: true }
    rescue => e
      { success: false, error: "Erro ao processar o arquivo: #{e.message}" }
    end
  end

  private

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

    if transaction_type.nil?
      Rails.logger.error "Tipo de transação não encontrado para o código: #{tipo}"
    end

    Transaction.new(
      transaction_type: transaction_type,
      date: Date.strptime(data, "%Y%m%d"),
      value: valor,
      cpf: cpf,
      card: cartao,
      time: hora,
      store_owner: dono_loja.strip,
      store_name: nome_loja.strip
    )
  end
end
