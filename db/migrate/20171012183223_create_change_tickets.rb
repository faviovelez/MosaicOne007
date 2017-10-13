class CreateChangeTickets < ActiveRecord::Migration
  def change
    create_table :change_tickets do |t|
      t.references :ticket, index: true, foreign_key: true
      t.integer :ticket_number

      t.timestamps null: false
    end
  end
end
