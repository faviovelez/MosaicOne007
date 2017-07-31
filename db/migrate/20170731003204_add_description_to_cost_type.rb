class AddDescriptionToCostType < ActiveRecord::Migration
  def change
    add_column :cost_types, :description, :string
  end
end
