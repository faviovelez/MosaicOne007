class DropUnit < ActiveRecord::Migration
  def change
    drop_table :units
  end
end
