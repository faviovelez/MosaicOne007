class CreateBillsChildren < ActiveRecord::Migration
  def change
    create_table :bills_children do |t|
      t.references :bill, index: true, foreign_key: true
      t.references :children, index: true

      t.timestamps null: false
    end
  end
end
