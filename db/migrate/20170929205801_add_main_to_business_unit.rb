class AddMainToBusinessUnit < ActiveRecord::Migration
  def change
    add_column :business_units, :main, :boolean, default: false
  end
end
