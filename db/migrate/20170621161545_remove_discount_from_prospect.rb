class RemoveDiscountFromProspect < ActiveRecord::Migration
  def change
    remove_column :prospects, :discount, :float
  end
end
