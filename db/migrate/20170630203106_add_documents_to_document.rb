class AddDocumentsToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :documents, :json
  end
end
