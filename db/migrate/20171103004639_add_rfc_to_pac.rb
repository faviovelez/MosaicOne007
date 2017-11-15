class AddRfcToPac < ActiveRecord::Migration
  def change
    add_column :pacs, :rfc, :string
  end
end
