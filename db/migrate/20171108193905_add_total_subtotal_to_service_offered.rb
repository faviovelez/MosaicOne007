class AddTotalSubtotalToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :total, :float
    add_column :service_offereds, :subtotal, :float
  end
end
