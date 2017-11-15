class CreateTicketsChildren < ActiveRecord::Migration
  def change
    create_table :tickets_children do |t|
      t.references :ticket, index: true, foreign_key: true
      t.references :children, index: true

      t.timestamps null: false
    end
  end
end
