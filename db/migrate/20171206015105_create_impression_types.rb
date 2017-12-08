class CreateImpressionTypes < ActiveRecord::Migration
  def change
    create_table :impression_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
