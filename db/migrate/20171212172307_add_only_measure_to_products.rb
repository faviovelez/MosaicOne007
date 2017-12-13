class AddOnlyMeasureToProducts < ActiveRecord::Migration
  def change
    add_column :products, :only_measure, :string
  end
end
