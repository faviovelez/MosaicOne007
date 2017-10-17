class DropSakKeys < ActiveRecord::Migration
  def change
    drop_table :sak_keys
  end
end
