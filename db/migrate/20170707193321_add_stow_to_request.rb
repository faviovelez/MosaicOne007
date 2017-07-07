class AddStowToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :boxes_stow, :string
  end
end
