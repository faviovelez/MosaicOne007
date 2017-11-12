class AddGroupProductToProduct < ActiveRecord::Migration
  def change
    add_column :products, :group, :boolean, default: false
  end
end
