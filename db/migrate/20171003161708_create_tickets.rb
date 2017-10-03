class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.references :user, index: true, foreign_key: true
      t.references :store, index: true, foreign_key: true
      t.float :subtotal
      t.references :tax, index: true, foreign_key: true
      t.float :taxes
      t.float :automatic_discount
      t.float :manual_discount
      t.float :total_discount
      t.float :total
      t.references :prospect, index: true, foreign_key: true
      t.references :payment, index: true, foreign_key: true
      t.references :bill, index: true, foreign_key: true
      t.string :ticket_type

      t.timestamps null: false
    end
  end
end
