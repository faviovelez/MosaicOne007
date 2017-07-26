class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :warehouse_cost_type

      t.timestamps null: false
    end
  end
end
