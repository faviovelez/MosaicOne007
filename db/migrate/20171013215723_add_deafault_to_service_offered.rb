class AddDeafaultToServiceOffered < ActiveRecord::Migration
  def change
    change_column :service_offereds, :manual_discount, :float, default: 0
    change_column :service_offereds, :automatic_discount, :float, default: 0
    change_column :service_offereds, :discount_applied, :float, default: 0
  end
end
