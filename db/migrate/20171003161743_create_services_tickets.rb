class CreateServicesTickets < ActiveRecord::Migration
  def change
    create_table :services_tickets do |t|
      t.references :ticket, index: true, foreign_key: true
      t.references :service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
