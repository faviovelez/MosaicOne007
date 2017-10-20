class CreateTemporalNumbers < ActiveRecord::Migration
  def change
    create_table :temporal_numbers do |t|
      t.references :store, index: true, foreign_key: true
      t.references :business_group, index: true, foreign_key: true
      t.string :past_sales, array: true, default: []
      t.string :future_sales, array: true, default: []

      t.timestamps null: false
    end
  end
end
