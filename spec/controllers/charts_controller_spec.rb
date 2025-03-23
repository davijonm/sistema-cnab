require 'rails_helper'

RSpec.describe ChartsController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe "GET #index" do
    let(:user) { create(:user) }
    let(:transaction_type1) { create(:transaction_type, description: 'Compra') }
    let(:transaction_type2) { create(:transaction_type, description: 'Venda') }

    # limpa o banco de dados antes de cada teste
    before do
      Transaction.destroy_all
      TransactionType.destroy_all

      create(:transaction, date: '2023-01-15', value: 100.0, store_name: 'Loja A', transaction_type: transaction_type1)
      create(:transaction, date: '2023-01-20', value: 150.0, store_name: 'Loja B', transaction_type: transaction_type2)
      create(:transaction, date: '2023-02-05', value: 200.0, store_name: 'Loja A', transaction_type: transaction_type1)
      create(:transaction, date: '2023-03-10', value: 300.0, store_name: 'Loja C', transaction_type: transaction_type2)
    end

    it "retorna http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "renderiza o template index" do
      get :index
      expect(response).to render_template(:index)
    end

    it "agrupa transacoes por mês corretamente" do
      get :index

      expect(assigns(:transactions_by_month).keys.map { |d| [d.year, d.month] }).to include([2023, 1], [2023, 2], [2023, 3])

      jan_2023 = assigns(:transactions_by_month).keys.find { |k| k.month == 1 && k.year == 2023 }
      fev_2023 = assigns(:transactions_by_month).keys.find { |k| k.month == 2 && k.year == 2023 }
      mar_2023 = assigns(:transactions_by_month).keys.find { |k| k.month == 3 && k.year == 2023 }

      expect(assigns(:transactions_by_month)[jan_2023]).to eq(250.0)
      expect(assigns(:transactions_by_month)[fev_2023]).to eq(200.0)
      expect(assigns(:transactions_by_month)[mar_2023]).to eq(300.0)
    end

    it "agrupa transacoes por loja corretamente" do
      get :index

      expect(assigns(:transactions_by_store).keys).to include('Loja A', 'Loja B', 'Loja C')

      expect(assigns(:transactions_by_store)['Loja A']).to eq(300.0)
      expect(assigns(:transactions_by_store)['Loja B']).to eq(150.0)
      expect(assigns(:transactions_by_store)['Loja C']).to eq(300.0)
    end

    it "agrupa transacoes por tipo corretamente" do
      get :index

      expect(assigns(:transactions_by_type).keys).to include('Compra', 'Venda')

      expect(assigns(:transactions_by_type)['Compra']).to eq(300.0)
      expect(assigns(:transactions_by_type)['Venda']).to eq(450.0)
    end
  end
end
