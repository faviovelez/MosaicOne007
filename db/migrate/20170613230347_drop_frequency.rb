class DropFrequency < ActiveRecord::Migration
  def change
    drop_table :frequencies
  end
end
