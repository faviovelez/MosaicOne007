class RemoveDesigners < ActiveRecord::Migration
  def change
    drop_table :designers
  end
end
