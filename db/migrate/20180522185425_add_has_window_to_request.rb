class AddHasWindowToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :has_window, :boolean, default: :false
  end
end
