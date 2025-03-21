require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let!(:transaction) { create(:transaction) }
  let!(:transaction_type) { create(:transaction_type) }

  describe 'GET #index' do
    it 'retorna uma lista de transações' do
      get :index, params: { page: 1, per_page: 10 }

      expect(response).to have_http_status(:success)
      expect(json_response['data']).to be_an(Array)
      expect(json_response['data'].count).to eq(10)
    end

    it 'ordena as transações por data de forma decrescente' do
      create(:transaction, date: 2.days.ago)

      get :index, params: { page: 1, per_page: 10 }

      expect(json_response['data'].first['attributes']['date']).to be >= json_response['data'].last['attributes']['date']
    end
  end

  describe 'GET #show' do
    it 'retorna uma transação específica' do
      get :show, params: { id: transaction.id }

      expect(response).to have_http_status(:success)
      expect(json_response['data']['id']).to eq(transaction.id.to_s)
    end
  end

  describe 'POST #create' do
    context 'quando o arquivo é enviado corretamente' do
      it 'processa o arquivo com sucesso' do
        file = fixture_file_upload('spec/fixtures/CNAB.txt', 'text/plain')

        post :create, params: { file: file }

        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Arquivo processado com sucesso!')
      end
    end

    context 'quando o arquivo não é enviado' do
      it 'retorna um erro de arquivo ausente' do
        post :create, params: {}

        expect(response).to have_http_status(:bad_request)
        expect(json_response['error']).to eq('Por favor, selecione um arquivo.')
      end
    end

    context 'quando o arquivo é inválido' do
      it 'retorna um erro ao processar o arquivo' do
        file = fixture_file_upload('spec/fixtures/INVALID_CNAB.txt', 'text/plain')

        post :create, params: { file: file }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Ops, há algo de errado com o arquivo.')
      end
    end
  end
end
