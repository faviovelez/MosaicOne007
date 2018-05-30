class AddDiscountToProspect < ActiveRecord::Migration
  def change
    add_column :prospects, :discount, :float, default: 0.0
  end
end
