class RenameOuterFromRequest < ActiveRecord::Migration
  def change
    rename_column :requests, :outer_widht, :outer_width
  end
end
