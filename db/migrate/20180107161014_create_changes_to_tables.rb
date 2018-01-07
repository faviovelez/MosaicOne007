class CreateChangesToTables < ActiveRecord::Migration
  def change
    create_table :changes_to_tables do |t|
      t.string :table
      t.integer :web_id
      t.integer :pos_id
      t.integer :store_id
      t.date :date

      t.timestamps null: false
    end
  end
end
