class CreateDateAdvises < ActiveRecord::Migration
  def change
    create_table :date_advises do |t|
      t.references :store, index: true, foreign_key: true
      t.references :prospect, index: true, foreign_key: true
      t.date :date
      t.references :ticket, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
