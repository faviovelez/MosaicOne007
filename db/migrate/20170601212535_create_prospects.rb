class CreateProspects < ActiveRecord::Migration
  def change
    create_table :prospects do |t|
      t.string :name
      t.string :type
      t.references :store, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
