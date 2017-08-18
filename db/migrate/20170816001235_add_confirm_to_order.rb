class AddConfirmToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :confirm, :boolean
  end
end
