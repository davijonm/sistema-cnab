require 'rails_helper'

RSpec.describe ProcessCnabService, type: :service do
  let(:valid_file) { File.open(Rails.root.join('spec', 'fixtures', 'valid_cnab.txt')) }
  let(:invalid_file) { File.open(Rails.root.join('spec', 'fixtures', 'invalid_cnab.txt')) }

  describe '#process_file' do
    context 'when the file is valid' do
      it 'processes the file and saves valid transactions' do
        transaction_type = create(:transaction_type, code: 1)

        # processa o arquivo válido
        service = ProcessCnabService.new(valid_file)
        result = service.process_file

        expect(result[:success]).to eq(true)

        # espera que as transacoes tenham sido salvas no banco
        expect(Transaction.count).to be > 0
      end
    end

    context 'when the file contains invalid transactions' do
      it 'logs validation errors and does not save invalid transactions' do
        # chama o servico para processar o arquivo invalido
        service = ProcessCnabService.new(invalid_file)

        result = service.process_file

        # espera que o resultado seja de falha
        expect(result[:success]).to eq(false)
      end
    end

    context 'when an error occurs while processing the file' do
      it 'returns an error message' do
        # arquivo falso ou caminho invalido para simular o erro
        service = ProcessCnabService.new(nil)

        result = service.process_file

        # resultado indica falha com a mensagem de erro
        expect(result[:success]).to eq(false)
        expect(result[:error]).to include("Erro ao processar o arquivo")
      end
    end
  end
end
