class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.string :status
      t.references :user, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
