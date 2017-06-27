class RemoveSheetFromRequest < ActiveRecord::Migration
  def change
    remove_column :requests, :sheet_length, :string
    remove_column :requests, :sheet_height, :string
  end
end
