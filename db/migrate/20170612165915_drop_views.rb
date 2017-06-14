class DropViews < ActiveRecord::Migration
  def change
    drop_table :views
  end
end
