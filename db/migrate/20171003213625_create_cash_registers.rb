class CreateCashRegisters < ActiveRecord::Migration
  def change
    create_table :cash_registers do |t|
      t.string :name
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
