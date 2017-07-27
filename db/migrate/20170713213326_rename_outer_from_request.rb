class RenameOuterFromRequest < ActiveRecord::Migration
  def change
    if column_exists? :requests, :outer_widht
      rename_column :requests, :outer_widht, :outer_width
    end
    unless column_exists? :requests, :outer_width
      add_column :requests, :outer_width
    end
  end
end
