class AddSelectedToCostType < ActiveRecord::Migration
  def change
    add_column :cost_types, :selected, :boolean
  end
end
