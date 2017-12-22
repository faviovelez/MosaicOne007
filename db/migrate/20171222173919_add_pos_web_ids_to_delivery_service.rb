class AddPosWebIdsToDeliveryService < ActiveRecord::Migration
  def change
    add_column :delivery_services, :pos_id, :integer
    add_column :delivery_services, :web_id, :integer
  end
end
