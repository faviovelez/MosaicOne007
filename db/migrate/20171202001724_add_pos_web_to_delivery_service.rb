class AddPosWebToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :pos, :boolean, default: false
    add_column :delivery_services, :web, :boolean, default: true
    add_column :delivery_services, :date, :date
  end
end
