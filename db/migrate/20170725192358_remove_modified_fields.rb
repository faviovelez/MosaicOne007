class RemoveModifiedFields < ActiveRecord::Migration
  def change
    drop_table :modified_fields
  end
end
