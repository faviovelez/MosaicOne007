class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.float :subtotal
      t.float :taxes_rate
      t.float :total
      t.references :store, index: true, foreign_key: true
      t.references :business_unit, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :bill_received, index: true, foreign_key: true
      t.integer :month
      t.integer :year
      t.date :expense_date

      t.timestamps null: false
    end
  end
end
