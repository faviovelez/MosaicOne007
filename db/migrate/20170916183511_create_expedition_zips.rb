class CreateExpeditionZips < ActiveRecord::Migration
  def change
    create_table :expedition_zips do |t|
      t.integer :zip

      t.timestamps null: false
    end
  end
end
