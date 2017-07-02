class AddDocumentssToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :documents, :string, array: true, default: []
  end
end
