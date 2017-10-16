class AddTotalCostToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :total_cost, :float
  end
end
