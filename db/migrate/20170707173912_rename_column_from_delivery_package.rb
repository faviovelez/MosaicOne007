class RenameColumnFromDeliveryPackage < ActiveRecord::Migration
  def change
    rename_column :delivery_packages, :lenght, :length
  end
end
