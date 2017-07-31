class RenameConfiguration < ActiveRecord::Migration
  def change
    rename_table :configurations, :cost_types
  end
end
