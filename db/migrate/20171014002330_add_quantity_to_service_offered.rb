class AddQuantityToServiceOffered < ActiveRecord::Migration
  def change
    add_column :service_offereds, :quantity, :integer
  end
end
