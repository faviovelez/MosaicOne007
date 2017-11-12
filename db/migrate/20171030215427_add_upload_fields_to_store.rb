class AddUploadFieldsToStore < ActiveRecord::Migration
  def change
    add_column :stores, :certificate, :string
    add_column :stores, :key, :string
  end
end
