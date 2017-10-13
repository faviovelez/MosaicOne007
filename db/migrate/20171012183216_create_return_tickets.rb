class CreateReturnTickets < ActiveRecord::Migration
  def change
    create_table :return_tickets do |t|
      t.references :ticket, index: true, foreign_key: true
      t.integer :ticket_number

      t.timestamps null: false
    end
  end
end
