class AddUniqueCodeInstallToStores < ActiveRecord::Migration
  def change
    add_column :stores, :install_code, :string
  end
end
