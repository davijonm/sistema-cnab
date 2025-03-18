class CreateTransactionTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :transaction_types do |t|
      t.integer :code
      t.string :description
      t.string :nature
      t.string :sign

      t.timestamps
    end
  end
end
