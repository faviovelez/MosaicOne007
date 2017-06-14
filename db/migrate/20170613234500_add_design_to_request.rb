class AddDesignToRequest < ActiveRecord::Migration
  def change
    add_column :requests, :require_design, :boolean
  end
end
