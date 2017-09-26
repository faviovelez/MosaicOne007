class AddStatusToPac < ActiveRecord::Migration
  def change
    add_column :pacs, :active, :boolean, default: true
  end
end
