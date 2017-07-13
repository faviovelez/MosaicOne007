class AddChangedToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :changed, :boolean
  end
end
