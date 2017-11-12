class RemoveAmountFromServiceOffered < ActiveRecord::Migration
  def change
    remove_column :service_offereds, :amount, :float
  end
end
