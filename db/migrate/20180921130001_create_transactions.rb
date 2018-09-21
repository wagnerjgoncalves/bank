class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :account, foreign_key: true, null: false
      t.decimal :amount, :decimal, precision: 9, scale: 2
      t.integer :kind, null: false

      t.timestamps
    end
  end
end
