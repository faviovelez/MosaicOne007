class CreateDesignCosts < ActiveRecord::Migration
  def change
    create_table :design_costs do |t|
      t.string :complexity
      t.float :cost

      t.timestamps null: false
    end
  end
end
