class RemoveUploadFilesFromStore < ActiveRecord::Migration
  def change
    remove_column :stores, :certificate, :string
    remove_column :stores, :key, :string
  end
end
