class DropProductionTable < ActiveRecord::Migration
  def change
    drop_table :productions
  end
end
