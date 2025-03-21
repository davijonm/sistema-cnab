module Api
  module V1
    class TransactionsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:create]

      def index
        transactions = Transaction.joins(:transaction_type)

        if params[:sort].present? && params[:direction].present?
          transactions = transactions.order("#{params[:sort]} #{params[:direction]}")
        else
          transactions = transactions.order(date: :desc)
        end

        render json: TransactionSerializer.new(
          transactions.page(params[:page]).per(params[:per_page] || 11),
          meta: {
            store_totals: calculate_store_totals
          }
        )
      end

      def show
        transaction = Transaction.find(params[:id])
        render json: TransactionSerializer.new(transaction)
      end

      def create
        if params[:file].present?
          result = ProcessCnabService.new(params[:file]).process_file

          if result[:success]
            render json: { message: "Arquivo processado com sucesso!" }, status: :ok
          else
            render json: { error: "Ops, há algo de errado com o arquivo." }, status: :unprocessable_entity
          end
        else
          render json: { error: "Por favor, selecione um arquivo." }, status: :bad_request
        end
      end

      private

      def calculate_store_totals
        transactions_by_store = Transaction.all.group_by(&:store_name)

        transactions_by_store.map do |store_name, transactions|
          total_balance = transactions.sum(&:value)
          { store_name: store_name, total_balance: total_balance }
        end
      end
    end
  end
end
