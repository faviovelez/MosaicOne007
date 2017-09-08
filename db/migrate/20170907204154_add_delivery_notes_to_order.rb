class AddDeliveryNotesToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_notes, :text
  end
end
