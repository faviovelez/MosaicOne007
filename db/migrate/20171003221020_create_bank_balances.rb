class CreateBankBalances < ActiveRecord::Migration
  def change
    create_table :bank_balances do |t|
      t.float :balance
      t.references :store, index: true, foreign_key: true
      t.references :business_unit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
