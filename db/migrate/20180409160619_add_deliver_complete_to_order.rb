class AddDeliverCompleteToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :deliver_complete, :boolean, default: false
  end
end
